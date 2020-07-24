import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_full_twitter/router/application.dart';

class NavigatorUtils {
  static void push(BuildContext context, String path, {
    bool replace = false, bool clearStack = false
  }) {
    unfocus();
    Application.router.navigateTo(context, path, replace: replace, clearStack: clearStack, transition: TransitionType.native);
  }

  static void unfocus() {
    /// 使用下面的方式，会触发不必要的build
    /// FocusScope.of(context).unfocus();
    /// https://github.com/flutter/flutter/issues/47128#issuecomment-627551073

    FocusManager.instance.primaryFocus?.unfocus();
  }
}