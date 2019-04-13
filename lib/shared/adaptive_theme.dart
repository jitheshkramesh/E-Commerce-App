import 'package:flutter/material.dart';

final ThemeData androidTheme = ThemeData(
  primarySwatch: Colors.deepOrange,
  accentColor: Colors.deepPurple,
  buttonColor: Colors.deepPurple,
);

final ThemeData iosTheme = ThemeData(
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  buttonColor: Colors.blue,
);

ThemeData getAdaptiveThemeData(context) {
  return Theme.of(context).platform == TargetPlatform.android
      ? androidTheme
      : iosTheme;
}
