import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../requests/requests.dart';
import '../models/news.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePage();
  }
}

class HomePage extends State {
  List<News> news = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() {
    fetchHome().then((data) {
      news = [];
      for (Map i in jsonDecode(data.body)['home']) {
        news.add(News.fromJson(i));
      }
      setState(() {
        news = news;
      });
    });

    Timer(Duration(seconds: 5), load);
  }

  @override
  Widget build(BuildContext context) {
    if (news.length == 0) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    News trending = news.first;

    return Scaffold(
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
