import 'package:alazkar/src/core/inputs/custom_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChange;

  const UserNumberField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChange,
        decoration: customInputDecorator.copyWith(hintText: hintText),
      ),
    );
  }
}
