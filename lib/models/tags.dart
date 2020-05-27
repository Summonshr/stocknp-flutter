import 'package:StockNp/models/news.dart';
import 'package:flutter/material.dart';

class Tags {
  final String name;

  final String slug;

  List<News> news;

  Tags.fromJson(Map json)
      : name = json['name'],
        slug = json['slug'];

  static List fromJsons(List items) {
    return items.map((e) => Tags.fromJson(e)).toList();
  }

  visit(context) {
    Navigator.pushNamed(context, 'tag', arguments: {'tag': this});
  }

  Widget toTitle(context) {
    return Text(this.name[0].toUpperCase() + this.name.substring(1),
        style: TextStyle(color: Colors.grey.shade800, fontSize: 35.0));
  }

  Widget widget(context, {String time, bool inverted = false}) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: SizedBox(
        height: 25.0,
        child: FlatButton(
            onPressed: () {
              this.visit(context);
            },
            color:
                name.toLowerCase() == 'trending' ? Colors.yellow : Colors.grey,
            child: Text('#' + name.toUpperCase(),
                style: TextStyle(fontSize: 12.0))),
      ),
    );
  }
}
