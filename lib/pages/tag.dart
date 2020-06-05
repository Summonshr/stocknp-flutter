import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/news.dart';
import 'package:StockNp/models/tags.dart';
import 'package:StockNp/storage/news.dart';
import 'package:StockNp/storage/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dynamic route = ModalRoute.of(context).settings.arguments;
    Tags tag = route['tag'];

    List<News> news =
        context.watch<NewsStorage>().taggedNews.where((News item) {
      return item.tag == tag.slug;
    }).toList();

    return Scaffold(
        drawer: CustomDrawer(),
        backgroundColor: context.watch<SettingsStorage>().backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
              color: context.watch<SettingsStorage>().headline1, size: 35.0),
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
