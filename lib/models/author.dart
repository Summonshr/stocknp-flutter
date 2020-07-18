import 'package:flutter/material.dart';

class Author {
  final String name;

  final String avatar;

  final String bio;

  Author.fromJson(Map json)
      : name = json['name'],
        bio = json['bio'],
        avatar = json['avatar'];

  Map<String, dynamic> toJson() {
    return {'name': name, 'bio': bio, 'avatar': avatar};
  }

  Widget widget({String time, bool inverted = false}) {
    return AuthorTile(
        avatar: avatar, name: name, time: time, inverted: inverted);
  }
}

class AuthorTile extends StatelessWidget {
  const AuthorTile(
      {Key key,
      @required this.avatar,
      @required this.name,
      this.time,
      this.inverted})
      : super(key: key);

  final String avatar;
  final String name;
  final String time;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        trailing: Icon(Icons.bookmark_border,
            color: inverted ? Colors.grey.shade700 : Colors.white),
        leading:
            CircleAvatar(radius: 25.0, backgroundImage: NetworkImage(avatar)),
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
