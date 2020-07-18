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

  int dangerColor = Colors.red.value;

  int successColor = Colors.green.value;

  int headline1 = Colors.grey.shade800.value;

  int headline2 = Colors.grey.shade600.value;

  int paragraph = Colors.grey.shade700.value;

  int blockquoteBackgroundColor = Colors.deepPurple.shade100.value;

  Settings.fromJson(Map<String, dynamic> json)
      : dark = json['dark'],
        activeColor = json['activeColor'],
        inactiveColor = json['inactiveColor'],
        backgrounColor = json['backgrounColor'],
        bookmarkColor = json['bookmarkColor'],
        dangerColor = json['dangerColor'],
        successColor = json['successColor'],
        headline1 = json['headline1'],
        headline2 = json['headline2'],
        paragraph = json['paragraph'],
        blockquoteBackgroundColor = json['blockquoteBackgroundColor'];

  Map<String, dynamic> toJson() {
    return {
      'dark': dark,
      'activeColor': activeColor,
      'inactiveColor': inactiveColor,
      'backgrounColor': backgrounColor,
      'bookmarkColor': bookmarkColor,
      'dangerColor': dangerColor,
      'successColor': successColor,
      'headline1': headline1,
      'paragraph': paragraph,
      'headline2': headline2,
      'blockquoteBackgroundColor': blockquoteBackgroundColor
    };
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

  Color get dangerColor => Color(settings.dangerColor);

  Color get successColor => Color(settings.successColor);

  Color get headline1 => Color(settings.headline1);

  Color get headline2 => Color(settings.headline2);

  Color get paragraph => Color(settings.paragraph);

  Color get blockquoteBackgroundColor =>
      Color(settings.blockquoteBackgroundColor);

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
