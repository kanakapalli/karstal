import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String authBoxName = 'authBox';
  static const String isLoggedInKey = 'isLoggedIn';
  static const String themeModeKey = 'themeMode';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(authBoxName);
  }

  static bool getIsLoggedIn() {
    final box = Hive.box(authBoxName);
    return box.get(isLoggedInKey, defaultValue: false) as bool;
  }

  static Future<void> setIsLoggedIn(bool value) async {
    final box = Hive.box(authBoxName);
    await box.put(isLoggedInKey, value);
  }

  static ThemeMode getThemeMode() {
    final box = Hive.box(authBoxName);
    final mode = box.get(themeModeKey, defaultValue: 'dark') as String;
    return mode == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final box = Hive.box(authBoxName);
    await box.put(themeModeKey, mode == ThemeMode.light ? 'light' : 'dark');
  }
}
