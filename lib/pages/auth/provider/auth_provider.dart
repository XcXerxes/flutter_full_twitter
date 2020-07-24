
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_twitter/helper/constant.dart';
import 'package:flutter_full_twitter/helper/enum.dart';
import 'package:flutter_full_twitter/helper/utils.dart';
import 'package:flutter_full_twitter/model/user.dart';
import 'package:flutter_full_twitter/provider/app_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oktoast/oktoast.dart';

class AuthProvider extends AppProvider {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  FirebaseUser user;
  String userId;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<User> _profileUserModelList;
  User _userModel;

  /// 获取用户相关信息
  User get userModel => _userModel;

  /// 获取用户列表最后
  User get profileUserModel {
    if(_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    }
    return null;
  }

  static final CollectionReference _userCollection =
    kfirestore.collection(USERS_COLLECTION);

  void removeLastUser() {
    _profileUserModelList.removeLast();
  }

  /// google 登录
  Future<FirebaseUser> handleGoogleSignIn() async{
    try {
      kAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if(googleUser == null) {
        throw Exception('Google login cancelled by user');
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      /// 获取得到用户信息
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      // 登录状态
      authStatus = AuthStatus.LOGGED_IN;
      userId = user.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user);
      notifyListeners();
      return user;
    } on PlatformException catch(error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } on Exception catch(error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    }
  }

  /// 创建通过google 登录的 用户信息
  createUserFromGoogleSignIn(FirebaseUser user) {
    var diff = DateTime.now().difference(user.metadata.creationTime);
    /// 检查用户是新的还是旧的
    if(diff < Duration(seconds: 15)) {
      User model = User(
        bio: 'Edit profile to update bio',
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3).toString(),
        location: 'Somewhere in universe',
        profilePic: user.photoUrl,
        displayName: user.displayName,
        email: user.email,
        key: user.uid,
        userId: user.uid,
        contact: user.phoneNumber,
        isVerified: user.isEmailVerified
      );
      createUser(model, newUser: true);
    } else {
      cprint('Last login at: ${user.metadata.lastSignInTime}');
    }
  }

  /// 登录
  Future<String> signIn(String email, String password) async {
    try {
      loading = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      user = result.user;
      userId = user.uid;
      return user.uid;
    } catch(error) {
      loading = false;
      cprint(error, errorIn: 'signIn');
      kAnalytics.logLogin(loginMethod: 'email_login');
      showToast(error.message);
      return null;
    }
  }

  /// 注册
  Future<String> signUp(User userModel, {String password}) async {
    try {
      loading = true;
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      kAnalytics.logSignUp(signUpMethod: 'register');
      /// 更新数据库
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = userModel.displayName;
      updateInfo.photoUrl = userModel.profilePic;
      await result.user.updateProfile(updateInfo);
      _userModel = userModel;
      _userModel.key = user.uid;
      _userModel.userId = user.uid;

    } catch(e) {
      loading = false;
      cprint(e, errorIn: 'signUp');
      showToast(e.message);
      return null;
    }
  }
  /// 重新加载用户信息
  reloadUser() async{
    await user.reload();
    user = await _firebaseAuth.currentUser();
    if (user.isEmailVerified) {
      userModel.isVerified = true;
      createUser(userModel);
      cprint('User email verification complete');
      logEvent('email_verification_complete',
          parameter: {userModel.userName: user.email});
    }
  }

  /// 更新 token
  updateFCMToken() {
    if(_userModel == null) {
      return;
    }
    getProfileUser();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _userModel.fcmToken = token;
      createUser(_userModel);
    });
  }

  /// 获取当前的用户信息
  Future<FirebaseUser> getCurrentUser() async {
    try {
      loading = true;
      logEvent('get_currentUSer');
      user = await _firebaseAuth.currentUser();
      if (user != null) {
        authStatus = AuthStatus.LOGGED_IN;
        userId = user.uid;
        getProfileUser();
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      loading = false;
      return user;
    } catch(error) {
      loading = false;
      cprint(error, errorIn: 'getCurrentUser');
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  /// 获取关注的列表
  Future<List<String>> getfollowersList(String userId) async {
    final List<String> follower = [];
    QuerySnapshot querySnapshot = await _userCollection
      .document(userId)
      .collection(FOLLOWER_COLLECTION)
      .getDocuments();
    if(querySnapshot != null && querySnapshot.documents.isNotEmpty) {
      querySnapshot.documents.first.data['data'].forEach((x) {
        follower.add(x);
      });
    }
    return follower;
  }

  /// 获取跟随者的列表
  Future<List<String>> getfollowingList(String userId) async {
    final List<String> follower = [];
    QuerySnapshot querySnapshot = await _userCollection
      .document(userId)
      .collection(FOLLOWING_COLLECTION)
      .getDocuments();
    if(querySnapshot != null && querySnapshot.documents.isNotEmpty) {
      querySnapshot.documents.first.data['data'].forEach((x) {
        follower.add(x);
      });
    }
    return follower;
  }

  /// 获取当前用户信息的内容
  getProfileUser({String userProfileId}) async {
    try {
      loading = true;
      if(_profileUserModelList == null) {
        _profileUserModelList = [];
      }
      userProfileId = userProfileId == null ? user.uid : userProfileId;
      // 根据id 获取用户信息
      var document = await _userCollection.document(userProfileId);
      document.get().then((DocumentSnapshot documentSnapshot) async{
        if(documentSnapshot.data != null) {
          _profileUserModelList.add(User.fromJson(documentSnapshot.data));

          /// get follower list
          final follower = await getfollowersList(userProfileId);
          _profileUserModelList.last.followersList = follower;
          _profileUserModelList.last.followers = follower.length;

          /// get following list
          final followingUsers = await getfollowingList(userProfileId);
          _profileUserModelList.last.followingList = followingUsers;
          _profileUserModelList.last.following = followingUsers.length;

          if(userProfileId == user.uid) {
            _userModel = _profileUserModelList.last;
            _userModel.isVerified = user.isEmailVerified;

            if(!user.isEmailVerified) {
              reloadUser();
            }
            if(_userModel.fcmToken == null) {
              updateFCMToken();
            }
          }
          logEvent('get_profile');
        }
        loading = false;
      });
    }catch(error) {
      loading = false;
      cprint(error, errorIn: 'getProfileUser');
    }
  }

  /// 创建 或者 更新 用户
  /// 如果 newUser 是 true 就是创建
  createUser(User user, {bool newUser = false}) {
    if(newUser) {
      // 创建用户
      user.userName = getUserName(id: user.userId, name: user.displayName);
      kAnalytics.logEvent(name: 'create_newUser');

      /// 更新用户创建时间
      user.createdAt = DateTime.now().toUtc().toString();
    }
    kfirestore
      .collection(USERS_COLLECTION)
      .document(user.userId)
      .setData(user.toJson());
    _userModel = user;
    if(_profileUserModelList != null) {
      _profileUserModelList.last = _userModel;
    }
    loading = false;
  }

}