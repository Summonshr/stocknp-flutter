import 'dart:async';

import 'package:StockNp/models/company.dart';
import 'package:StockNp/storage/companies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalBought {
  int total;

  double per;

  final String name;

  TotalBought({this.name, this.total, this.per});

  Map<String, dynamic> toJson() {
    return {
      'per': per,
      'name': name,
      'total': total,
    };
  }

  TotalBought.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        per = json['per'],
        total = json['total'];

  double actualCost() {
    return total * per;
  }

  double profitIfSoldAt(double price) {
    return sellAt(price) - totalCost();
  }

  double profitIfSoldNow(context) {
    Company company = Provider.of<CompanyStorage>(context)
        .companies
        .firstWhere((Company company) => company.symbol == name);
    return sellAt(company.price) - totalCost();
  }

  double profitPercentageIfSoldNow(context) {
    Company company = Provider.of<CompanyStorage>(context)
        .companies
        .firstWhere((Company company) => company.symbol == name);
    return ((sellAt(company.price) - totalCost()) / totalCost()) * 100;
  }

  double profitPercentageIfSoldAt(double price) {
    return ((sellAt(price) - totalCost()) / totalCost()) * 100;
  }

  double actualCostPerQuantity() {
    return totalCost() / total;
  }

  double sellNow(context) {
    Company company = Provider.of<CompanyStorage>(context)
        .companies
        .firstWhere((Company company) => company.symbol == name);

    double sellTotal = company.price * total;

    double receivalble =
        sellTotal - commission(sellTotal) - sebonFee(sellTotal) - 25;

    double totalC = totalCost();

    if (receivalble > totalC) {
      receivalble = receivalble - (receivalble - totalC) * 5 / 100;
    }
    return receivalble;
  }

  double sellAt(price) {
    return price * total;
  }

  double commission(cost) {
    if (cost <= 50000) {
      return 0.0060 * cost;
    }

    if (cost <= 500000) {
      return 0.0055 * cost;
    }

    if (cost <= 2000000) {
      return 0.005 * cost;
    }

    if (cost <= 2000000) {
      return 0.0045 * cost;
    }

    return 0.0040 * cost;
  }

  double sebonFee(cost) {
    return 0.00015 * cost;
  }

  double totalCost() {
    return (total * per) +
        25 +
        commission(actualCost()) +
        sebonFee(actualCost());
  }

  TableRow editWidget(context, editor, deleter) {
    return TableRow(decoration: BoxDecoration(), children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(total.toString()),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(actualCostPerQuantity()
            .toStringAsFixed(2)
            .replaceAll(RegExp(r"([.]*00)(?!.*\d)"), "")),
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
