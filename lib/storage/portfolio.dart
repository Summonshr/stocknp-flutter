import 'dart:convert';

import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/models/total-bought.dart';
import 'package:StockNp/storage/file-storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PortfolioStorage with ChangeNotifier {
  int get itemsCount => items.length;

  List<PortfolioItem> get portfolios => items;
  List<TotalBought> get totalBoughts => boughts;
  String get current => expanded;
  String expanded;

  List<PortfolioItem> items = [];
  List<TotalBought> boughts = [];

  void removeItem(name) {
    items.removeWhere((PortfolioItem item) => item.name == name);
    boughts.removeWhere((TotalBought bought) => bought.name == name);

    updateItemsInStore();

    updateBoughtsInStore();

    notifyListeners();
  }

  void updateItemsInStore() {
    String json =
        jsonEncode(items.map((PortfolioItem item) => item.toJson()).toList());
    Storage().store('portfolios', json);
  }

  void setExpanded(String item) {
    if (item != expanded) {
      expanded = item;
    } else {
      expanded = '';
    }
    notifyListeners();
  }

  void insertPortfolio(PortfolioItem item) {
    items.add(item);

    updateItemsInStore();
    notifyListeners();
  }

  void loadBoughts(List<TotalBought> items) {
    boughts = items;
    notifyListeners();
  }

  void loadPortfolios(List<PortfolioItem> portfolios) {
    items = portfolios;
    notifyListeners();
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

    updateBoughtsInStore();

    notifyListeners();
  }

  void updateBoughtsInStore() {
    String json =
        jsonEncode(boughts.map((TotalBought item) => item.toJson()).toList());
    Storage().store('boughts', json);
  }

  void removeBought(hashCode) {
    boughts.removeWhere((TotalBought item) => item.hashCode == hashCode);
    updateBoughtsInStore();
    notifyListeners();
  }
}
