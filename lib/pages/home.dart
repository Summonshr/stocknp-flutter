import 'dart:async';
import 'dart:convert';
import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/storage/news.dart';
import 'package:flutter/material.dart';
import '../requests/requests.dart';
import '../models/news.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State {
  @override
  void initState() {
    super.initState();
    load();
  }

  load() {
    fetchHome().then((data) {
      List<News> newsItems = [];
      for (Map i in jsonDecode(data.body)['home']) {
        newsItems.add(News.fromJson(i));
      }
      context.read<NewsStorage>().storeNews(newsItems);
      Timer(Duration(seconds: 30), load);
    }).catchError((error) {
      Timer(Duration(seconds: 180), load);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<News> news = context.watch<NewsStorage>().news;
    if (news.length == 0) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    News trending = news.first;

    return Scaffold(
      drawer: CustomDrawer(route: 'home'),
      body: Column(
        children: <Widget>[
          trending.widget(context),
          Expanded(
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Divider(),
                ...news.sublist(1).map((News news) => news.toList(context))
              ],
            )),
          )
        ],
      ),
    );
  }
}
