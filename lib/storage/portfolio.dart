import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/models/total-bought.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PortfolioStorage with ChangeNotifier, DiagnosticableTreeMixin {
  int get itemsCount => items.length;

  List<PortfolioItem> get portfolios => items;
  List<TotalBought> get totalBoughts => boughts;

  List<PortfolioItem> items = [];
  List<TotalBought> boughts = [];

  void insertPortfolio(PortfolioItem item) {
    items.add(item);
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
    notifyListeners();
  }

  void removeBought(hashCode) {
    boughts.removeWhere((TotalBought item) => item.hashCode == hashCode);
    notifyListeners();
  }
}
