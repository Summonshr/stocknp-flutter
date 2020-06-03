import 'package:flutter/material.dart';

class TotalBought {
  int total;

  double per;

  TotalBought({this.total, this.per});

  TableRow editWidget(context, editor, deleter) {
    return TableRow(decoration: BoxDecoration(), children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(total.toString()),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
            per.toStringAsFixed(2).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text((total * per)
            .toStringAsFixed(2)
            .replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")),
      ),
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(onTap: editor, child: Icon(Icons.edit)),
              InkWell(onTap: deleter, child: Icon(Icons.delete)),
            ],
          ))
    ]);
  }
}
