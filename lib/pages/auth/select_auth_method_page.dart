import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/pages/auth/widget/auth_button.dart';
import 'package:flutter_full_twitter/router/auth_router.dart';
import 'package:flutter_full_twitter/router/navigator_utils.dart';
import 'package:flutter_full_twitter/widget/title_text.dart';

class SelectAuthMethodPage extends StatefulWidget {
  @override
  _SelectAuthMethodPageState createState() => _SelectAuthMethodPageState();
}

class _SelectAuthMethodPageState extends State<SelectAuthMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image.asset('assets/images/icon-480.png', width: 40, height: 40, fit: BoxFit.fill),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: <Widget>[
          _buildContent(),
          _buildFooter()
        ],
      ),
    );
  }

  _buildContent() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleText(
            text: "查看世界正在发生的新鲜事。",
            fontSize: 25,
          ),
          SizedBox(height: 20),
          _submitButton(context)
        ],
      ),
    );
  }

  _submitButton (BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: AuthButton(
        child: TitleText(
          text: '创建账号',
          color: Colors.white,
        ),
        onPressed: _submit,
      )
    );
  }
  /// 创建账户
  _submit() {
    NavigatorUtils.push(context, AuthRouter.signup);
  }


  _buildFooter() {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: Row(
        children: <Widget>[
          TitleText(
            text: '已经有账号了?',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          InkWell(
            onTap: () {
              NavigatorUtils.push(context, AuthRouter.signin);
            },
            child: Container(
              margin: EdgeInsets.only(left: 4),
              child: Text('登录', style: TextStyle(
               color: Theme.of(context).primaryColor
              )),
            ),
          )
        ],
      ),
    );
  }
}
