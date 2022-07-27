import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textController,
    required this.hintText,
    this.isPass = false,
    this.textInputType = TextInputType.emailAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      obscureText: isPass,
      keyboardType: textInputType,
    );
  }
}
