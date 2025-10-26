import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<bool> {
  ThemeNotifier() : super(true); // يبدأ بالدارك مود

  void toggleTheme() => value = !value;
}
