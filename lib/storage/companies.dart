import 'package:StockNp/models/company.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CompanyStorage with ChangeNotifier {
  List<Company> get companies => companyLists;
  List<String> get filters => selectedFilters;
  List<Company> companyLists = [];

  List<String> selectedFilters = [
    'Equity',
    'Mutual Funds',
    'Non-Convertible Debentures'
  ];

  void data({List<Company> companies}) {
    companyLists = companies;
  }

  void setFilter(String key, bool value) {
    if (value) {
      selectedFilters.add(key);
    }

    if (!value) {
      selectedFilters.remove(key);
    }
    notifyListeners();
  }
}
