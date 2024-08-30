import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  IconData get icon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.smartphone;
    }
  }

  void setThemeMode (ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void changeTheme (ThemeMode mode) {
    setThemeMode(mode);
  }
}