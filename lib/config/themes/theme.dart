import 'package:flutter/material.dart';

bool getThemeMode(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  return brightness == Brightness.dark;
}
