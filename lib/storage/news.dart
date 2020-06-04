import 'dart:convert';

import 'package:StockNp/models/news.dart';
import 'package:StockNp/storage/file-storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NewsStorage with ChangeNotifier {
  List<News> get news => newsList;
  List<News> newsList = [];
  void storeNews(List<News> items) {
    newsList = items;
    Storage().store('news',
        jsonEncode(newsList.map((News news) => news.toJson()).toList()));
    notifyListeners();
  }

  void load(List<News> items) {
    newsList = items;
    notifyListeners();
  }
}
