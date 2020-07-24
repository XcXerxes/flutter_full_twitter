import 'package:flutter/material.dart';

TextStyle get titleStyle { return  TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold,);}

class TwitterColor {
  static final Color bondiBlue = Color.fromRGBO(0, 132, 180, 1);
  static final Color white = Color.fromRGBO(255, 255, 255, 1.0);
  static final Color dodgetBlue = Color.fromRGBO(29, 162, 240, 1.0);
}

class AppColor {
  static final Color primary = Color(0xff4FA1EC);
  static final Color white = Color(0xFFffffff);
  static final Color darkGrey = Color(0xff1657786);
}

class AppTheme{
  static final ThemeData apptheme = ThemeData(
    primaryColor: AppColor.primary,
    primarySwatch: Colors.blue,
    backgroundColor: TwitterColor.white,
    accentColor: TwitterColor.dodgetBlue,
    brightness: Brightness.light,
    cardColor: Colors.white,
    unselectedWidgetColor: Colors.grey,
    bottomAppBarColor: Colors.white,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColor.white
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: TwitterColor.white,
      iconTheme: IconThemeData(color: TwitterColor.dodgetBlue),
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontStyle: FontStyle.normal
        ),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelStyle: titleStyle.copyWith(color: TwitterColor.dodgetBlue),
      unselectedLabelColor: AppColor.darkGrey,
      unselectedLabelStyle: titleStyle.copyWith(color: AppColor.darkGrey),
      labelColor: TwitterColor.dodgetBlue,
      labelPadding: EdgeInsets.symmetric(vertical: 12)
    )
  );
}
