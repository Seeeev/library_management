import 'package:flutter/material.dart';

InputDecoration getDecoration(labelText) {
  return InputDecoration(
    labelText: labelText,
    fillColor: Colors.white,
    filled: true,
    border: const OutlineInputBorder(),
  );
}
