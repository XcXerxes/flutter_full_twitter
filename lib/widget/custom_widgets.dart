import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final int icon;
  final bool isEnable;
  final double size;
  final bool istwitterIcon;
  final bool isFontAwesomeRegular;
  final bool isFontAwesomeSolid;
  final Color iconColor;
  final double paddingIcon;

  CustomIcon({
    this.icon,
    this.isEnable = false,
    this.size = 18,
    this.istwitterIcon = true,
    this.isFontAwesomeRegular = false,
    this.isFontAwesomeSolid = false,
    this.iconColor,
    this.paddingIcon = 10
  });

  @override
  Widget build(BuildContext context) {
    Color iconCor = iconColor ?? Theme.of(context).textTheme.caption.color;
    return Padding(
      padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
      child: Icon(
        IconData(icon, fontFamily: istwitterIcon
          ? 'TwitterIcon' : isFontAwesomeRegular ? 'AwesomeRegular'
            : isFontAwesomeSolid ? 'AwesomeSolid' : 'Fontello'
        ),
        size: size,
        color: isEnable ? Theme.of(context).primaryColor : iconCor,
      ),
    );
  }
}
