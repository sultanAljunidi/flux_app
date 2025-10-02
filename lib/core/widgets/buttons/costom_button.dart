import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.color,
    this.borderRadius,
    this.width,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    required this.onTap,
    Color? backgroundColor,
  });
  final double? height;
  final double? width;
  final Color? color;
  final double? borderRadius;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius ?? 50),
      onTap: onTap,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(borderRadius ?? 50),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(borderRadius ?? 50),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: fontWeight ?? FontWeight.bold,
                fontSize: fontSize ?? 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
