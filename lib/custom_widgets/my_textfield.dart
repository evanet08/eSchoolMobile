import 'package:flutter/material.dart';
import 'my_text.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final int maxLines;
  final double width;
  final double height;
  final bool passwordField;
  final TextInputType textInputType;
  final Function(dynamic)? onChanged;
  final Function(dynamic)? onSaved;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const MyTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.width,
    this.height = 35.0,
    this.maxLines = 1,
    this.textInputType = TextInputType.text,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.passwordField = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          label: MyText(text: label),
          hintText: placeholder,
        ),
        maxLines: maxLines,
        textAlignVertical: TextAlignVertical.center,
        obscureText: passwordField,
        enableSuggestions: passwordField,
        autocorrect: passwordField,
        keyboardType: textInputType,
        cursorColor: Colors.black,
      ),
    );
  }
}
