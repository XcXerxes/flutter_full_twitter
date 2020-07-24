import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/pages/auth/signin_page.dart';
import 'package:flutter_full_twitter/pages/auth/signup_page.dart';
import 'package:flutter_full_twitter/pages/auth/select_auth_method_page.dart';
import 'package:flutter_full_twitter/pages/auth/verify_email_page.dart';
import 'package:flutter_full_twitter/router/init_router.dart';

class AuthRouter implements IRouterProvider {

  static String signin = '/signin';
  static String signup = '/signup';
  static String verifyEmail = '/verify-email';
  static String selectAuthMethod = '/select-auth-method';

  @override
  initRouter(Router router) {
    router.define(signin, handler: Handler(
      handlerFunc: (BuildContext context, _) => SignInPage()
    ));
    router.define(signup, handler: Handler(
        handlerFunc: (BuildContext context, _) => SignUpPage()
    ));
    router.define(verifyEmail, handler: Handler(
        handlerFunc: (BuildContext context, _) => VerifyEmailPage()
    ));
    router.define(selectAuthMethod, handler: Handler(
        handlerFunc: (BuildContext context, _) => SelectAuthMethodPage()
    ));
  }
}