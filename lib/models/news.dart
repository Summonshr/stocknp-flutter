import 'package:StockNp/components/bookmark.dart';
import 'package:StockNp/models/author.dart';
import 'package:StockNp/models/tags.dart';
import 'package:StockNp/pages/single.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class News {
  final String title;

  final String image;

  final Author author;

  final String time;

  final List<Tags> tags;

  final String body;

  final String id;

  final bool trending;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'featured_image': image,
      'author': author.toJson(),
      'tags': tags.map((Tags item) => item.toJson()).toList(),
      'publish_date': time,
      'body': body,
      'trending': trending
    };
  }

  News.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        image = json['featured_image'],
        author = Author.fromJson(json['author']),
        tags = Tags.fromJsons(json['tags']),
        time = json['publish_date'],
        body = json['body'],
        trending = json['trending'];

  Widget header(context, {bool larger = false, Color color}) {
    return larger
        ? Text(title,
            style: TextStyle(
                fontFamily: 'OpenSans',
                color: color ?? Colors.white,
                fontSize: 25.0))
        : Text(title,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: color ?? Colors.grey.shade700));
  }

  visit(context) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: Single(),
            settings:
                RouteSettings(name: 'single', arguments: {"news": this})));
  }

  Widget toList(BuildContext context) {
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
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: Colors.grey.shade600)),
                          ),
                          Spacer(),
                          BookMark(id: id)
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

  Widget isTrending() {
    bool trending =
        this.tags.where((tag) => tag.name.toLowerCase() == 'trending').length >
            0;
    return trending
        ? SizedBox(
            height: 25.0,
            child: FlatButton(
                onPressed: () {},
                color: Colors.yellow,
                child: Text('trending'.toUpperCase(),
                    style: TextStyle(fontSize: 12.0))),
          )
        : SizedBox(
            height: 25.0,
            child: FlatButton(
                onPressed: () {},
                color: Colors.greenAccent,
                child: Text('latest'.toUpperCase(),
                    style: TextStyle(fontSize: 12.0))),
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
          isTrending(),
          SizedBox(
            height: 5.0,
          ),
          InkWell(
              onTap: () {
                this.visit(context);
              },
              child: header(context, larger: true)),
          ListTile(
              contentPadding: EdgeInsets.all(0.0),
              trailing: BookMark(id: id),
              leading: CircleAvatar(
                  radius: 25.0, backgroundImage: NetworkImage(author.avatar)),
              title: Text(author.name, style: TextStyle(color: Colors.white)),
              subtitle: time == null
                  ? null
                  : Text(time, style: TextStyle(color: Colors.white))),
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
