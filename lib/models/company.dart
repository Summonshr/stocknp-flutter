import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Company {
  final String name;

  final String securityName;

  final String symbol;

  final String status;

  final String url;

  final String regulatoryBody;

  final int id;

  final double price;

  final String email;

  final String type;

  final String sectorName;

  final String website;

  final double eps;

  final double bvps;

  final double npl;

  final double income;

  final double growth;

  final double chg;

  Company.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        symbol = json['symbol'],
        securityName = json['security_name'],
        website = json['website'],
        status = json['status'],
        price = double.tryParse(json['price'].toString()),
        email = json['email'],
        regulatoryBody = json['regulatory_body'],
        sectorName = json['sector_name'],
        url = json['url'],
        eps = double.tryParse(json['eps'].toString()),
        bvps = double.tryParse(json['bvps'].toString()),
        npl = double.tryParse(json['npl'].toString()),
        chg = double.tryParse(json['change_status'].toString()),
        growth = double.tryParse(json['growth'].toString()),
        income = double.tryParse(json['income'].toString()),
        type = json['type'];

  Widget toList(context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
      padding:
          EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 10.0),
      child: InkWell(
        onTap: () {
          AlertDialog alert = AlertDialog(
            title: Text(name + ' ($symbol)'),
            backgroundColor: Colors.blue.shade50,
            content: Wrap(
              children: <Widget>[
                if (eps != 0)
                  Text('Earning per share: ' + eps.toStringAsFixed(2),
                      style: TextStyle(height: 1.7)),
                if (bvps != 0)
                  Text('Book Value per share: ' + bvps.toStringAsFixed(2),
                      style: TextStyle(height: 1.7)),
                if (npl != 0.0)
                  Text('Non-performing loan: ' + npl.toStringAsFixed(2),
                      style: TextStyle(height: 1.7)),
                if (income != 0.0)
                  Text(
                      'Income: Rs. ' +
                          NumberFormat.compactLong().format(income * 10),
                      style: TextStyle(height: 1.7)),
                if (growth != 0.0)
                  Text('Income growth: ' + growth.toStringAsFixed(2) + '%',
                      style: TextStyle(height: 1.7)),
              ],
            ),
            actions: [],
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(symbol,
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    if (sectorName != 'Debentures' &&
                        sectorName != 'Mutual Fund')
                      Text.rich(TextSpan(
                          text: 'EPS: ',
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: eps.toStringAsFixed(2),
                                style: TextStyle(
                                    color:
                                        eps < 10.0 ? Colors.red : Colors.green))
                          ])),
                    if (sectorName != 'Debentures' &&
                        sectorName != 'Mutual Fund')
                      Text.rich(TextSpan(
                          text: ' Growth: ',
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: growth.toStringAsFixed(2) + '%',
                                style: TextStyle(
                                    color:
                                        growth > 0 ? Colors.green : Colors.red))
                          ])),
                    if (sectorName == 'Mutual Fund')
                      Text.rich(TextSpan(
                          text: 'Nav: ',
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                                text: bvps.toStringAsFixed(2),
                                style: TextStyle(
                                    color:
                                        bvps >= 10 ? Colors.green : Colors.red))
                          ])),
                  ],
                )
              ],
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Text(
                  'Rs ' + price.toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
                Icon(chg > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: chg > 0 ? Colors.green : Colors.red)
              ],
            )
          ],
        ),
      ),
    );
  }
}
