/*
 * @Description: 
 * @Author: leo
 * @Date: 2020-07-23 21:23:36
 * @LastEditors: leo
 * @LastEditTime: 2020-07-24 00:19:59
 */
/*
 * @Description: 
 * @Author: leo
 * @Date: 2020-07-23 21:23:36
 * @LastEditors: leo
 * @LastEditTime: 2020-07-24 00:14:31
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:flutter_full_twitter/helper/constant.dart';
import 'package:flutter_full_twitter/helper/utils.dart';
import 'package:flutter_full_twitter/model/feedModel.dart';
import 'package:flutter_full_twitter/model/user.dart';
import 'package:flutter_full_twitter/provider/app_provider.dart';

class HomeProvider extends AppProvider {
  bool isBusy = false;
  Map<String, List<FeedModel>> tweetReplyMap = {};

  /// 个人发帖 模型
  FeedModel _tweetToReplyModel;
  FeedModel get tweetToReplyModel => _tweetToReplyModel;
  set setTweetToReply(FeedModel model) {
    _tweetToReplyModel = model;
  }

  /// 评论列表
  List<FeedModel> _commentlist;

  List<FeedModel> _feedlist;
  dabase.Query _feedQuery;
  List<FeedModel> _tweetDetailModelList;
  List<FeedModel> get tweetDetailModel => _tweetDetailModelList;

  // 粉丝列表
  List<String> _userfollowingList;
  List<String> get followingList => _userfollowingList;

  /// fire模型 实例
  static final CollectionReference _tweetCollection =
      kfirestore.collection(TWEET_COLLECTION);

  /// 获取得到 feedlist
  List<FeedModel> get feedlist {
    if (_feedlist == null) {
      return null;
    }
    return List.from(_feedlist.reversed);
  }

  /// 获取tweetList
  List<FeedModel> getTweetList(User userModel) {
    if (userModel == null) {
      return null;
    }
    List<FeedModel> list;

    if (!isBusy && feedlist != null && feedlist.isNotEmpty) {
      list = feedlist.where((x) {
        if (x.parentkey != null &&
            x.childRetwetkey != null &&
            x.user.userId != userModel.userId) {
          return false;
        }

        if (x.user.userId == userModel.userId ||
            (userModel?.followingList != null &&
                userModel.followingList.contains(x.user.userId))) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  set setFeedModel(FeedModel model) {
    if (_tweetDetailModelList == null) {
      _tweetDetailModelList = [];
    }

    if (_tweetDetailModelList.length >= 0) {
      _tweetDetailModelList.add(model);

      cprint(
          "Detail Tweet added. Total Tweet: ${_tweetDetailModelList.length}");
    }
  }

  /// firebase Database
  Future<bool> databaseInit() {
    try {
      if (_feedQuery == null) {
        _feedQuery = kDatabase.child('tweet');
        _tweetCollection.snapshots().listen((QuerySnapshot snapshot) {
          if (snapshot.documentChanges.first.type == DocumentChangeType.added) {
            _onTweetAdded(snapshot.documentChanges.first.document);
          } else if (snapshot.documentChanges.first.type ==
              DocumentChangeType.removed) {
//            _onTweetRemoved(snapshot.documentChanges.first.document);
          } else if (snapshot.documentChanges.first.type ==
              DocumentChangeType.modified) {
            _onTweetChanged(snapshot.documentChanges.first.document);
          }
        });
      }
      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  /// Trigger when new tweet added
  _onTweetAdded(DocumentSnapshot event) {
    FeedModel tweet = FeedModel.fromJson(event.data);
    tweet.key = event.documentID;

    _onCommentAdded(tweet);
    if (_feedlist == null) {
      _feedlist = List<FeedModel>();
    }
    if ((_feedlist.length == 0 ||
            _feedlist.any((element) => element.key != tweet.key)) &&
        tweet.isValidTweet) {
      _feedlist.add(tweet);
      cprint('Tweet Added');
    }
    isBusy = false;
    notifyListeners();
  }

  /// Tirgger when comment tweet added
  _onCommentAdded(FeedModel tweet) {
    if (tweet.childRetwetkey != null) {
      return;
    }
    if (tweetReplyMap != null && tweetReplyMap.length > 0) {
      if (tweetReplyMap[tweet.parentkey] != null) {
        tweetReplyMap[tweet.parentkey].add(tweet);
      } else {
        tweetReplyMap[tweet.parentkey] = [tweet];
      }
      cprint('Comment Added');
    }
    isBusy = false;
    notifyListeners();
  }

  _onTweetChanged(DocumentSnapshot event) {
    if(event.data == null) {
      return;
    }

    var model = FeedModel.fromJson(event.data);
    model.key = event.documentID;
    if(_feedlist.any((element) => element.key == model.key)) {
      var oldEntry = _feedlist.lastWhere((element) => element.key == event.documentID);
      _feedlist[_feedlist.indexOf(oldEntry)] = model;
    }

    if(_tweetDetailModelList != null && _tweetDetailModelList.length > 0) {
      if (_tweetDetailModelList.any((x) => x.key == model.key)) {
        var oldEntry = _tweetDetailModelList.lastWhere((entry) {
          return entry.key == event.documentID;
        });
        _tweetDetailModelList[_tweetDetailModelList.indexOf(oldEntry)] = model;
      }

      if(tweetReplyMap != null && tweetReplyMap.length > 0) {
        var list = tweetReplyMap[model.parentkey];
        if(list != null && list.length > 0) {
          var index = list.indexOf(list.firstWhere((element) => element.key == model.key));
          list[index] = model;
        } else {
          list = [];
          list.add(model);
        }
      }
    }

    cprint('Tweet updated');
    isBusy = false;
    notifyListeners();
  }

  /// 从数据库中获取数据
  getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();

      _tweetCollection.getDocuments().then((QuerySnapshot querySnapshot) {
        _feedlist = List<FeedModel>();

        if (querySnapshot != null && querySnapshot.documents.isNotEmpty) {
          for (var i = 0; i < querySnapshot.documents.length; i++) {
            var model = FeedModel.fromJson(querySnapshot.documents[i].data);
            model.key = querySnapshot.documents[i].documentID;
            _feedlist.add(model);
          }

          /// Sort Tweet by time
          /// It helps to display newest Tweet first.
          _feedlist.sort((x, y) => DateTime.parse(x.createdAt)
              .compareTo(DateTime.parse(y.createdAt)));
          notifyListeners();
        } else {
          _feedlist = null;
        }
      });
      isBusy = false;
    } catch (e) {
      isBusy = false;
      cprint(e, errorIn: 'getDataFromDatabase');
    }
  }

  /// fetch Tweet
  Future<FeedModel> fetchTweet(String postID) async {
    FeedModel _tweetDetail;

    if (feedlist.any((element) => element.key == postID)) {
      _tweetDetail = feedlist.firstWhere((element) => element.key == postID);
    } else {
      cprint("Fetched from DB: " + postID);

      var model = await kDatabase
          .child('tweet')
          .child(postID)
          .once()
          .then((dabase.DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var map = snapshot.value;
          _tweetDetail = FeedModel.fromJson(map);
          _tweetDetail.key = snapshot.key;
          print(_tweetDetail.description);
        }
      });

      if (model != null) {
        _tweetDetail = model;
      } else {
        cprint("Fetched null value from  DB");
      }
    }
    return _tweetDetail;
  }

  /// create [New Tweet]
  Future<void> createTweet(FeedModel model) async {
    isBusy = true;
    notifyListeners();
    try {
      await _tweetCollection.document().setData(model.toJson());
    } catch (e) {
      cprint(e, errorIn: 'createTweet');
    }
    isBusy = false;
    notifyListeners();
  }
}
