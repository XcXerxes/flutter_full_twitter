import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/helper/constant.dart';
import 'package:flutter_full_twitter/helper/enum.dart';
import 'package:flutter_full_twitter/model/user.dart';
import 'package:flutter_full_twitter/pages/auth/widget/auth_button.dart';
import 'package:flutter_full_twitter/pages/auth/widget/google_login_button.dart';
import 'package:flutter_full_twitter/pages/auth/provider/auth_provider.dart';
import 'package:flutter_full_twitter/router/navigator_utils.dart';
import 'package:flutter_full_twitter/router/routers.dart';
import 'package:flutter_full_twitter/widget/loader_widget.dart';
import 'package:flutter_full_twitter/widget/title_text.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  Loader _loader = Loader();

  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
  }

  /// 提交注册
  _submitForm() {
    if(verifyForm()) {
      _loader.showLoader(context);
      var provider = Provider.of<AuthProvider>(context, listen: false);
      Random random = Random();
      int randomNumber = random.nextInt(8);

      User user = User(
        email: _emailController.text.toLowerCase(),
        bio: 'Edit profile to update bio',
        displayName: _nameController.text,
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3).toString(),
        location: 'Somewhere in universe',
        profilePic: dummyProfilePicList[randomNumber],
        isVerified: false
      );

      provider.signUp(user, password: _passwordController.text)
        .then((status) {
         print(status);
      }).whenComplete(() {
        _loader.hideLoader();
        if(provider.authStatus == AuthStatus.LOGGED_IN) {
          NavigatorUtils.push(context, Routes.main);
        }
      });
    }
  }

  /// 验证form
  bool verifyForm() {
    if (_nameController.text.isEmpty) {
      showToast('请输入名字.');
      return false;
    }
    if(_emailController.text.isEmpty) {
      showToast('请输入邮箱.');
      return false;
    }
    if(_passwordController.text == null || _passwordController.text.isEmpty || _confirmController.text == null
      || _confirmController.text.isEmpty
    ) {
      showToast('请输入密码.');
      return false;
    } else if(_passwordController.text != _confirmController.text) {
      showToast('两次密码输出不一致.');
      return false;
    }
    return true;
  }

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
  /// 渲染主体内容
  _buildBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _entryFeild('名字', controller: _nameController),
            SizedBox(height: 5),
            _entryFeild('邮箱', controller: _emailController, isEmail: true, maxLength: 27),
            SizedBox(height: 5),
            _entryFeild('密码', controller: _passwordController, isPassword: true),
            SizedBox(height: 5),
            _entryFeild('确认密码', controller: _confirmController, isPassword: true),
            _buildButtonSubmit(),
            Divider(height: 30),
            SizedBox(height: 20),
            GoogleLoginButton()
          ],
        ),
      )
    );
  }

  /// 渲染渲染button
  _buildButtonSubmit() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 30),
      width: double.infinity,
      child: AuthButton(
        onPressed: _submitForm,
        child: TitleText(
          color: Colors.white,
          text: '注册',
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
