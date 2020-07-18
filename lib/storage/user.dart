import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class UserStorage with ChangeNotifier {
  FirebaseUser get currentUser => user;

  FirebaseUser user;

  void updateUser(FirebaseUser u) {
    user = u;
    notifyListeners();
  }
}
