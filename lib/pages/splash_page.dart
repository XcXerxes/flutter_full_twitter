import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/helper/enum.dart';
import 'package:flutter_full_twitter/helper/theme.dart';
import 'package:flutter_full_twitter/pages/auth/provider/auth_provider.dart';
import 'package:flutter_full_twitter/router/application.dart';
import 'package:flutter_full_twitter/router/auth_router.dart';
import 'package:flutter_full_twitter/router/navigator_utils.dart';
import 'package:flutter_full_twitter/router/routers.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      duration: Duration(milliseconds: 300), vsync: this, value: .1
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUser(context);
    });
    super.initState();
  }

  animationTimer(AuthStatus authStatus) {
    Timer(Duration(milliseconds: 2500), () {
      _controller.forward();
      Timer(Duration(milliseconds: 100), () {
        if (authStatus != AuthStatus.LOGGED_IN) {
          Application.router.navigateTo(context, Routes.main, transition: TransitionType.fadeIn);
        } else {
          Application.router.navigateTo(context, AuthRouter.selectAuthMethod, transition: TransitionType.fadeIn);
        }
      });
    });
  }

  fetchUser(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    provider.getCurrentUser().then((status) {
      animationTimer(provider.authStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset('assets/images/white_logo.png', width: 1000, height: 1000, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
