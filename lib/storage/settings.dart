import 'package:StockNp/storage/file-storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Settings {
  Settings();
  bool dark = false;

  int activeColor = Colors.green.value;

  int inactiveColor = Colors.black.value;

  int backgrounColor = Colors.white.value;

  int bookmarkColor = Colors.purple.value;

  Settings.fromJson(Map<String, dynamic> json) : dark = json['dark'];

  Map<String, dynamic> toJson() {
    return {'dark': dark};
  }

  void sync() {
    Storage().store('settings', this.toJson());
  }
}

class SettingsStorage with ChangeNotifier {
  bool get dark => settings.dark;

  Color get activeColor => Color(settings.activeColor);

  Color get inactiveColor => Color(settings.inactiveColor);

  Color get backgroundColor => Color(settings.backgrounColor);

  Color get bookmarkColor => Color(settings.bookmarkColor);

  Settings settings = Settings();

  void loadsettings(Settings items) {
    settings = items;
  }

  void toggleDarkMode() {
    settings.dark = !settings.dark;
    settings.sync();
    notifyListeners();
  }
}
