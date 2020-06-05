import 'dart:convert';

import 'package:StockNp/models/news.dart';
import 'package:StockNp/storage/file-storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NewsStorage with ChangeNotifier {
  List<News> get news => newsList;
  List<News> newsList = [];
  List<String> marks = [];
  List<String> get bookmarks => marks;
  void storeNews(List<News> items) {
    newsList = items;
    Storage().store('news',
        jsonEncode(newsList.map((News news) => news.toJson()).toList()));
    notifyListeners();
  }

  void loadBookmarks(List<String> items) {
    marks = items;
    notifyListeners();
  }

  void load(List<News> items) {
    newsList = items;
    notifyListeners();
  }

  void updateBookmarks(String id) {
    if (marks.where((String str) => str == id).toList().length > 0) {
      marks.removeWhere((String str) => str == id);
    } else {
      marks.add(id);
    }

    Storage().store('bookmarks', jsonEncode(marks));
    notifyListeners();
  }
}
