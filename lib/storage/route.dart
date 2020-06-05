import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class RouteStorage with ChangeNotifier {
  String get currentRoute => route;
  String route = 'home';
  void update(String r) {
    route = r;
    notifyListeners();
  }
}
