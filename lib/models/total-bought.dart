import 'package:flutter/material.dart';

class TotalBought {
  int total;

  double per;

  TotalBought({this.total, this.per});

  TableRow editWidget(context) {
    return TableRow(decoration: BoxDecoration(), children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(total.toString()),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            per.toStringAsFixed(2).replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Rs. ' +
            (total * per)
                .toStringAsFixed(2)
                .replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")),
      )
    ]);
  }
}
