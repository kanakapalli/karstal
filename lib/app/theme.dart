import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF101014),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF18181C),
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    cardColor: const Color(0xFF18181C),
    dialogBackgroundColor: const Color(0xFF18181C),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      fillColor: Color(0xFF23232A),
      filled: true,
      hintStyle: TextStyle(color: Colors.white54),
    ),
    dividerColor: Colors.white12,
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white70,
      textColor: Colors.white,
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.amber,
      background: Color(0xFF101014),
      surface: Color(0xFF18181C),
    ),
  );
}
