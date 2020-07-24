import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/helper/constant.dart';
import 'package:flutter_full_twitter/pages/home/home_page.dart';
import 'package:flutter_full_twitter/pages/home/provider/home_provider.dart';
import 'package:flutter_full_twitter/pages/message/message_page.dart';
import 'package:flutter_full_twitter/pages/notification/notification_page.dart';
import 'package:flutter_full_twitter/pages/search/search_page.dart';
import 'package:flutter_full_twitter/widget/custom_widgets.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void initTweets() {
    var provider = Provider.of<HomeProvider>(context, listen: false);
    provider.databaseInit();
    provider.getDataFromDatabase();
  }

  List<Widget> _pageViewList = [
    HomePage(),
    SearchPage(),
    NotificationPage(),
    MessagePage()
  ];

  int _currentPage = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initTweets();
    });
    _controller = PageController(initialPage: 0);
    // TODO: implement initState
    super.initState();
  }

  PageController _controller;

  BottomNavigationBarItem _buildNavBarItem(int icon, int activeIcon) {
    return BottomNavigationBarItem(
        title: SizedBox(height: 0),
        icon: CustomIcon(icon: icon),
        activeIcon: CustomIcon(icon: activeIcon, isEnable: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: _pageViewList,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: <BottomNavigationBarItem>[
          _buildNavBarItem(AppIcon.home, AppIcon.homeFill),
          _buildNavBarItem(AppIcon.search, AppIcon.searchFill),
          _buildNavBarItem(AppIcon.notification, AppIcon.notificationFill),
          _buildNavBarItem(AppIcon.messageEmpty, AppIcon.messageFill)
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (int page) {
          _controller.jumpToPage(page);
        },
      ),
    );
  }
}
