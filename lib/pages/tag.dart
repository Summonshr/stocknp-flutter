import 'dart:convert';

import 'package:StockNp/models/news.dart';
import 'package:flutter/material.dart';
import '../requests/requests.dart';

class Tag extends StatefulWidget {
  Tag({Key key}) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  dynamic tag;
  List<News> news;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tag == null) {
      dynamic route = ModalRoute.of(context).settings.arguments;
      tag = route['tag'];
      setState(() {
        tag = tag;
      });
      postsBySlug(tag.slug).then((data) {
        news = [];
        for (Map i in jsonDecode(data.body)['news']) {
          news.add(News.fromJson(i));
          setState(() {
            news = news;
          });
        }
      }).catchError((
        a,
      ) {});
    }

    if (tag == null) {
      return Scaffold(
        body: Container(),
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.grey.shade900, size: 25.0),
          elevation: 0.0, // Removes background
          title: tag.toTitle(context),
          actions: <Widget>[],
        ),
        body: SafeArea(
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              if (news != null && news.length > 0)
                ...news.map((News item) => item.toList(context)).toList()
            ],
          )),
        ));
  }
}
