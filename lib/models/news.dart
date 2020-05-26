import './author.dart';
import 'package:flutter/material.dart';

class News {
  final String title;

  final String image;

  final Author author;

  final String time;

  final String url;

  final String body;

  final String id;

  final bool trending;

  News.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        image = json['featured_image'],
        author = Author.fromJson(json['author']),
        time = json['publish_date'],
        body = json['body'],
        url = json['url'],
        trending = json['trending'];

  Widget header(context, {bool larger = false, Color color}) {
    return larger
        ? Text(title,
            style: TextStyle(color: color ?? Colors.white, fontSize: 25.0))
        : Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: color ?? Colors.grey.shade700));
  }

  visit(context) {
    Navigator.pushNamed(context, 'single', arguments: {'news': this});
  }

  Widget toList(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              bottom: 7.5, left: 15.0, top: 7.5, right: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  this.visit(context);
                },
                child: Image(
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                  image: NetworkImage(image),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            this.visit(context);
                          },
                          child: header(context)),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              this.visit(context);
                            },
                            child: Text(time,
                                style: TextStyle(color: Colors.grey.shade600)),
                          ),
                          Spacer(),
                          Icon(Icons.bookmark_border,
                              color: Colors.grey.shade500)
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget widget(context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Spacer(),
          SizedBox(
            height: 25.0,
            child: FlatButton(
                onPressed: () {},
                color: Colors.yellow,
                child: Text('Trending'.toUpperCase(),
                    style: TextStyle(fontSize: 12.0))),
          ),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'single',
                    arguments: {'news': this});
              },
              child: header(context, larger: true)),
          author.widget(context, time: time),
        ],
      ),
      width: size.width,
      height: size.height / 2.5,
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.blueGrey.shade300, BlendMode.multiply),
              fit: BoxFit.cover,
              image: NetworkImage(image))),
    );
  }
}
