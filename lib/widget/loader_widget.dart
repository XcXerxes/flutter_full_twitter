
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader {
  static Loader _loader;

  Loader._createObject();

  factory Loader() {
    if(_loader != null) {
      return _loader;
    } else {
      _loader = Loader._createObject();
      return _loader;
    }
  }

  OverlayState _overlayState;
  OverlayEntry _overlayEntry;

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: buildLoader(context),
        );
      }
    );
  }

  showLoader(context) {
    _overlayState = Overlay.of(context);
    _buildLoader();
    _overlayState.insert(_overlayEntry);
  }

  hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch(e) {
      print('Exception: $e');
    }
  }

  buildLoader(BuildContext context, {Color backgroundColor}) {
    if (backgroundColor == null) {
      backgroundColor = const Color(0xffa8a8a8).withOpacity(.5);
    }
    var height = 150.0;
    return ScreenLoader(
      height: height,
      width: height,
      backgroundColor: backgroundColor,
    );
  }
}


class ScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;

  ScreenLoader({
    this.backgroundColor = const Color(0xfff8f8f8),
    this.height = 30,
    this.width = 30
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Platform.isIOS ? CupertinoActivityIndicator(radius: 35) : CircularProgressIndicator(strokeWidth: 2),
              Image.asset('assets/images/icon-480.png', height: 30, width: 30)
            ],
          ),
        ),
      ),
    );
  }
}
