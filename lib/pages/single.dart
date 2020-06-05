import 'package:StockNp/components/bookmark.dart';
import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/tags.dart';
import 'package:StockNp/storage/settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Single extends StatelessWidget {
  Single({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context).settings.arguments;

    dynamic news = arguments['news'];

    return Scaffold(
      drawer: CustomDrawer(),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      trailing: BookMark(id: news.id),
                      leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(news.author.avatar)),
                      title: Text(news.author.name,
                          style: TextStyle(
                              color:
                                  context.watch<SettingsStorage>().headline1)),
                      subtitle: Text(news.time,
                          style: TextStyle(
                              color:
                                  context.watch<SettingsStorage>().headline2))),
                ),
                Padding(
                    child: news.header(context,
                        larger: true,
                        color: context.watch<SettingsStorage>().headline1),
                    padding: EdgeInsets.only(
                        top: 5.0, bottom: 15.0, left: 20.0, right: 20.0)),
                FadeInImage.assetNetwork(
                    placeholder: './images/logo.png', image: news.image),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: HtmlView(
                      scrollable: false,
                      data: news.body,
                      styleSheet: MarkdownStyleSheet(
                          blockSpacing: 15.0,
                          codeblockDecoration: BoxDecoration(
                              color:
                                  context.watch<SettingsStorage>().dangerColor),
                          blockquote: TextStyle(),
                          blockquotePadding: 20.0,
                          blockquoteDecoration: BoxDecoration(
                              color: context
                                  .watch<SettingsStorage>()
                                  .blockquoteBackgroundColor),
                          horizontalRuleDecoration: BoxDecoration(
                              border: Border(top: BorderSide(width: 1.0))),
                          p: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.none,
                              fontSize: 18.0,
                              height: 1.7,
                              color:
                                  context.watch<SettingsStorage>().paragraph)),
                    )),
                Divider(
                  height: 20.0,
                ),
                Wrap(
                  children: [
                    ...news.tags.map((Tags tag) => tag.widget(context)).toList()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
