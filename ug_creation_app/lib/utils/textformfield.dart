import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ugbussinesscard/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? initValue;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final int? maxLines;
  final int? minLines;

  const CustomTextField(
      {Key? key,
      this.hint,
      this.textEditingController,
      this.keyboardType,
      this.validator,
      this.obscureText = false,
      this.initValue,
      this.textStyle,
      this.decoration,
      this.maxLines,
      this.minLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TextFormField(
        controller: textEditingController,
        style: textStyle,
        keyboardType: keyboardType,
        textAlign: TextAlign.left,
        cursorColor: HexColor(appGreyColor),
        validator: validator,
        maxLines: maxLines,
        minLines: minLines,
        initialValue: initValue,
        obscureText: obscureText ?? false,
        decoration: decoration,
      ),
    );
  }
}
