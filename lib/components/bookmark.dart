import 'package:StockNp/storage/news.dart';
import 'package:StockNp/storage/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookMark extends StatelessWidget {
  final String id;

  BookMark({this.id});

  isMarked(BuildContext context) {
    return context
            .watch<NewsStorage>()
            .bookmarks
            .where((String str) => str == id)
            .toList()
            .length >
        0;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<NewsStorage>().updateBookmarks(id),
      child: Icon(
          this.isMarked(context) ? Icons.bookmark : Icons.bookmark_border,
          color: context.watch<SettingsStorage>().bookmarkColor),
    );
  }
}
