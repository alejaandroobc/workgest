import 'package:flutter/material.dart';

class MyViewModel with ChangeNotifier {

  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

}
