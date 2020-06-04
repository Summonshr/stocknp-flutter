import 'dart:convert';

import 'package:StockNp/models/company.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CompanyStorage with ChangeNotifier, DiagnosticableTreeMixin {
  List<Company> get companies => companyLists;
  List<Company> companyLists = [];

  void data({List<Company> companies}) {
    print(jsonEncode(companies));
    companyLists = companies;
  }
}
