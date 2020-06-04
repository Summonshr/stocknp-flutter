import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/models/total-bought.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Items with ChangeNotifier, DiagnosticableTreeMixin {
  int get itemsCount => items.length;

  List<PortfolioItem> get portfolios => items;
  List<TotalBought> get totalBoughts => boughts;
  List<Company> get companies => companyLists;
  FirebaseUser get currentUser => user;

  List<PortfolioItem> items = [];
  List<TotalBought> boughts = [];
  List<Company> companyLists = [];
  FirebaseUser user;

  void updateUser(FirebaseUser u) {
    user = u;
    notifyListeners();
  }

  void insertPortfolio(PortfolioItem item) {
    items.add(item);
    notifyListeners();
  }

  void data({List<Company> companies}) {
    print('asdf');
    companyLists = companies;
  }

  void updateBoughts(TotalBought item) {
    bool exists = false;
    boughts = boughts.map((TotalBought bought) {
      if (bought.hashCode == item.hashCode) {
        exists = true;
        return item;
      }
      return bought;
    }).toList();

    if (!exists) {
      boughts.add(item);
    }
    notifyListeners();
  }

  void removeBought(hashCode) {
    boughts.removeWhere((TotalBought item) => item.hashCode == hashCode);
    notifyListeners();
  }
}
