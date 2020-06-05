import 'package:StockNp/components/bookmark.dart';
import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Single extends StatefulWidget {
  Single({Key key}) : super(key: key);

  @override
  _SingleState createState() => _SingleState();
}

class _SingleState extends State<Single> {
  String html;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context).settings.arguments;

    dynamic news = arguments['news'];

    return Scaffold(
      drawer: CustomDrawer(route: 'single'),
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
                          style: TextStyle(color: Colors.grey.shade800)),
                      subtitle: Text(news.time,
                          style: TextStyle(color: Colors.grey.shade600))),
                ),
                Padding(
                    child: news.header(context,
                        larger: true, color: Colors.grey.shade900),
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
                          codeblockDecoration: BoxDecoration(color: Colors.red),
                          blockquote: TextStyle(),
                          blockquotePadding: 20.0,
                          blockquoteDecoration:
                              BoxDecoration(color: Colors.deepPurple.shade100),
                          horizontalRuleDecoration: BoxDecoration(
                              border: Border(top: BorderSide(width: 1.0))),
                          p: TextStyle(
                              fontFamily: 'OpenSans',
                              decoration: TextDecoration.none,
                              fontSize: 18.0,
                              height: 1.7,
                              color: Colors.grey.shade800)),
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
