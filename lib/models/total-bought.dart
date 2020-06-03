import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TotalBought {
  int total;

  double per;

  String name;

  TotalBought({this.name, this.total, this.per});

  double actualCost() {
    return total * per;
  }

  double profitIfSoldAt(double price) {
    return sellAt(price) - actualCost();
  }

  double profitPercentageIfSoldAt(double price) {
    return ((sellAt(price) - actualCost()) / actualCost()) * 100;
  }

  double sellAt(price) {
    return price * total;
  }

  double commission() {
    if (actualCost() <= 50000) {
      return 0.0060 * actualCost();
    }

    if (actualCost() <= 500000) {
      return 0.0055 * actualCost();
    }

    if (actualCost() <= 2000000) {
      return 0.005 * actualCost();
    }

    if (actualCost() <= 2000000) {
      return 0.0045 * actualCost();
    }

    return 0.0040 * actualCost();
  }

  double sebonFee() {
    return 0.00015 * actualCost();
  }

  double totalCost() {
    return (total * per) + 25 + commission() + sebonFee();
  }

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
        child: Text(totalCost()
            .toStringAsFixed(2)
            .replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")),
      ),
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                  onTap: editor,
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue.shade400,
                  )),
              InkWell(
                  onTap: () {
                    CupertinoAlertDialog dialog = new CupertinoAlertDialog(
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Timer(Duration(milliseconds: 500), deleter);
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                      title: Text('Delete this entry?'),
                    );
                    showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return dialog;
                        });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red.shade500,
                  )),
            ],
          ))
    ]);
  }
}
