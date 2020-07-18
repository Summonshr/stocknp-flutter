import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Widget child;
  const Box({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
