/*
 * @Description: 
 * @Author: leo
 * @Date: 2020-07-23 20:21:42
 * @LastEditors: leo
 * @LastEditTime: 2020-07-23 23:58:03
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_twitter/helper/theme.dart';
import 'package:flutter_full_twitter/pages/home/provider/home_provider.dart';
import 'package:flutter_full_twitter/pages/splash_page.dart';
import 'package:flutter_full_twitter/provider/app_provider.dart';
import 'package:flutter_full_twitter/pages/auth/provider/auth_provider.dart';
import 'package:flutter_full_twitter/router/application.dart';
import 'package:flutter_full_twitter/router/routers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    final Router router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
      ],
      child: OKToast(
        child: MaterialApp(
          title: 'Full Twitter',
          theme: AppTheme.apptheme.copyWith(
              textTheme:
                  GoogleFonts.muliTextTheme(Theme.of(context).textTheme)),
          onGenerateRoute: Application.router.generator,
          home: SplashPage(),
        ),
        position: ToastPosition.center,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
