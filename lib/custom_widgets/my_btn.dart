import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final Color textColor;
  final Color buttonColor;
  final Function() onPressed;

  const MyButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    this.borderRadius = 5.0,
    required this.fontSize,
    required this.textColor,
    required this.onPressed,
    this.buttonColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(onPressed: onPressed, child: Text(text)),
      ),
    );
  }
}
