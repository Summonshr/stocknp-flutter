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
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: news.author
                      .widget(context, inverted: true, time: news.time),
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
                          p: TextStyle(
                              fontSize: 18.0,
                              height: 1.7,
                              color: Colors.grey.shade800)),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
