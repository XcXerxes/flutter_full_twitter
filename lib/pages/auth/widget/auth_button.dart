import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  AuthButton({
    this.child,
    this.onPressed
  });
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      color: Theme.of(context).accentColor,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: child,
    );
  }
}
