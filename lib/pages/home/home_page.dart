/*
 * @Description: 
 * @Author: leo
 * @Date: 2020-07-23 21:13:15
 * @LastEditors: leo
 * @LastEditTime: 2020-07-23 23:57:13
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_full_twitter/model/feedModel.dart';
import 'package:flutter_full_twitter/pages/auth/provider/auth_provider.dart';
import 'package:flutter_full_twitter/pages/home/provider/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final List<FeedModel> list =
            provider.getTweetList(authProvider.userModel);
        return extended.NestedScrollView(
          pinnedHeaderSliverHeightBuilder: () {
            return MediaQuery.of(context).padding.top + kToolbarHeight;
          },
          headerSliverBuilder: _buildAppBar,
          body: EasyRefresh.custom(slivers: [
            SliverList(
                delegate: SliverChildListDelegate(list.map((model) {
              return Container(
                color: Colors.white,
                child: Text('1111'),
              );
            }).toList()))
          ]),
        );
      },
      child: null,
    );
  }

  List<Widget> _buildAppBar(BuildContext context, innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        floating: true,
        title: Image.asset('assets/images/icon-480.png',
            width: 40, height: 40, fit: BoxFit.fill),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.color,
      )
    ];
  }
}
