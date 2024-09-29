import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(String text) {
    if (text.isEmpty) return;

    final snackBar = SnackBar(content: Text(text));

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // Método para adicionar espaço vertical
  static SizedBox addVerticalSpace(double height) {
    return SizedBox(height: height);
  }

  // Método para adicionar espaço horizontal
  static SizedBox addHorizontalSpace(double width) {
    return SizedBox(width: width);
  }
}
