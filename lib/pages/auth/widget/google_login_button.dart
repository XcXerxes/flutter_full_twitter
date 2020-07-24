import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/helper/utils.dart';
import 'package:flutter_full_twitter/pages/auth/provider/auth_provider.dart';
import 'package:flutter_full_twitter/router/navigator_utils.dart';
import 'package:flutter_full_twitter/router/routers.dart';
import 'package:flutter_full_twitter/widget/loader_widget.dart';
import 'package:flutter_full_twitter/widget/title_text.dart';
import 'package:provider/provider.dart';

class GoogleLoginButton extends StatelessWidget {

  /// 谷歌登录
  _googleLogin(BuildContext context) {
    Loader loader = Loader();
    var provider = Provider.of<AuthProvider>(context, listen: false);
    loader.showLoader(context);
    provider.handleGoogleSignIn()
      .then((status) {
        if(provider.user != null) {
          loader.hideLoader();
          NavigatorUtils.push(context, Routes.main);
        } else {
          loader.hideLoader();
          cprint('Unable to login', errorIn: '_googleLoginButton');
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        onPressed: () => _googleLogin(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/google_logo.png', width: 20, height: 20),
            SizedBox(width: 10),
            TitleText(
              text: 'Continue with Google',
              color: Colors.black54,
            )
          ],
        ),
      ),
    );
  }
}
