import 'package:flutter/material.dart';

class Author {
  final String name;

  final String image;

  final String bio;

  Author.fromJson(Map json)
      : name = json['name'],
        bio = json['bio'],
        image = json['avatar'];

  Widget widget(context, {String time, bool inverted = false}) {
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        trailing: Icon(Icons.bookmark_border,
            color: inverted ? Colors.grey.shade700 : Colors.white),
        leading:
            CircleAvatar(radius: 25.0, backgroundImage: NetworkImage(image)),
        title: Text(name,
            style: TextStyle(
                color: inverted ? Colors.grey.shade700 : Colors.white)),
        subtitle: time == null
            ? null
            : Text(time,
                style: TextStyle(
                    color: inverted ? Colors.grey.shade600 : Colors.white)));
  }
}
