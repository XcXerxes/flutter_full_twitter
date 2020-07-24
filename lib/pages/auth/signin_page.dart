import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/helper/utils.dart';
import 'package:flutter_full_twitter/pages/auth/provider/auth_provider.dart';
import 'package:flutter_full_twitter/pages/auth/widget/auth_button.dart';
import 'package:flutter_full_twitter/pages/auth/widget/google_login_button.dart';
import 'package:flutter_full_twitter/router/navigator_utils.dart';
import 'package:flutter_full_twitter/router/routers.dart';
import 'package:flutter_full_twitter/widget/loader_widget.dart';
import 'package:flutter_full_twitter/widget/title_text.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emaliEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  GlobalKey _formKey = GlobalKey<FormState>();
  Loader loader = Loader();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset('assets/images/icon-480.png', width: 40, height: 40, fit: BoxFit.fill),
      ),
      body: SingleChildScrollView(child: _buildBody()),
    );
  }
  /// 验证form
  verifyForm() {
    if(_emaliEditingController.text == null || _emaliEditingController.text.isEmpty) {
      showToast('请输入邮箱');
      return false;
    }
    if (_passwordEditingController.text == null || _passwordEditingController.text.isEmpty) {
      showToast('请输入密码');
      return false;
    }
    return true;
  }
  /// 提交邮箱登录
  _submit() {
    if(verifyForm()) {
      loader.showLoader(context);
      var provider = Provider.of<AuthProvider>(context, listen: false);
      provider.signIn(_emaliEditingController.text, _passwordEditingController.text)
        .then((status) {
         if(provider.user != null) {
           loader.hideLoader();
           NavigatorUtils.push(context, Routes.main);
         } else {
           cprint('Unable to login', errorIn: '_emailLoginButton');
           loader.hideLoader();
         }
      });
    }
  }

  _buildBody () {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _entryFeild('邮箱', controller: _emaliEditingController, isEmail: true),
            SizedBox(height: 5),
            _entryFeild('密码', controller: _passwordEditingController, isPassword: true),
            _buildSubmitButton(),
            SizedBox(height: 50),
            _buildNavPassword(),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 20),
            GoogleLoginButton()
          ],
        ),
      ),
    );
  }

  /// 渲染忘记密码按钮
  _buildNavPassword() {
    return InkWell(
      onTap: () {

      },
      child: TitleText(
        text: '忘记密码？',
        color: Theme.of(context).accentColor,
        fontSize: 16,
      ),
    );
  }

  /// 渲染提交按钮
  _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 30),
      width: double.infinity,
      child: AuthButton(
        onPressed: _submit,
        child: TitleText(
          text: '邮箱登录',
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  /// 渲染表单
  _entryFeild(String hintText, {
    TextEditingController controller,
    bool isPassword = false,
    bool isEmail = false,
    int maxLength
  }) {
    return Container(
      child: TextField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,

        ),
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            counter: Offstage()
        ),
      ),
    );
  }
}
