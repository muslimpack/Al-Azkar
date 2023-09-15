import 'package:flutter/material.dart';

final customInputDecorator = InputDecoration(
  filled: true,
  border: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(10.0),
  ),
  contentPadding: const EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
);
