import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_full_twitter/pages/main.dart';
import 'package:flutter_full_twitter/pages/splash_page.dart';
import 'package:flutter_full_twitter/router/auth_router.dart';
import 'package:flutter_full_twitter/router/init_router.dart';

class Routes {
  static String main = '/main';
  static String splash = '/splash';

  static List<IRouterProvider> _listRouter = [];

  static void configureRoutes(Router router) {
    /// 指定路由跳转错误返回页

    router.define(splash, handler: Handler(
      handlerFunc: (BuildContext context, dynamic params) => SplashPage()
    ));

    router.define(main, handler: Handler(
      handlerFunc: (BuildContext context, _) => MainPage()
    ));

    _listRouter.clear();

    /// 各自路由各自模块管理 统一初始化
    _listRouter.add(AuthRouter());

    /// 初始化路由
    _listRouter.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }
}
