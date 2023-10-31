import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoe_shop_3/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppTheme.lightTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == AppTheme.lightTheme
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;
    notifyListeners();
  }
}
