import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TitleText extends StatelessWidget {

  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow textOverflow;

  TitleText({
    this.text,
    this.fontSize = 18,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w800,
    this.textAlign = TextAlign.left,
    this.textOverflow = TextOverflow.visible
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.muli(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color
      ),
      textAlign: textAlign,
      overflow: textOverflow,
    );
  }
}
