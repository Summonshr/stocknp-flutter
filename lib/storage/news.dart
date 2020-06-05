import 'dart:convert';

import 'package:StockNp/models/news.dart';
import 'package:StockNp/requests/requests.dart';
import 'package:StockNp/storage/file-storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class NewsStorage with ChangeNotifier {
  List<News> get news => newsList;
  List<News> newsList = [];
  List<News> taggedNews = [];
  List<String> marks = [];
  List<String> get bookmarks => marks;
  void storeNews(List<News> items) {
    newsList = items;
    Storage().store('news',
        jsonEncode(newsList.map((News news) => news.toJson()).toList()));
    notifyListeners();
  }

  void loadByTags(slug) {
    if (taggedNews.where((News news) => news.tag == slug).length > 0) {
      return;
    }
    postsBySlug(slug).then((data) {
      List<News> news = [];
      for (Map i in jsonDecode(data.body)['news']) {
        i['tag'] = slug;
        News neww = News.fromJson(i);
        news.add(neww);
      }
      taggedNews = news;
      notifyListeners();
    }).catchError((
      a,
    ) {});
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
