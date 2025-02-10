import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() {
    const seedColor = Colors.lightBlue;
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      listTileTheme: const ListTileThemeData(
        iconColor: seedColor
      )
    );
  }
}