import './author.dart';
import './tags.dart';
import 'package:flutter/material.dart';

class Company {
  final String name;

  final String securityName;

  final String symbol;

  final String status;

  final String url;

  final String regulatoryBody;

  final int id;

  final String email;

  final String type;

  final String sectorName;

  final String website;

  Company.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        symbol = json['symbol'],
        securityName = json['security_name'],
        website = json['website'],
        status = json['status'],
        email = json['email'],
        regulatoryBody = json['regulatory_body'],
        sectorName = json['sector_name'],
        url = json['url'],
        type = json['type'];

  Widget toList(context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1.0))),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: InkWell(
        onTap: () {
          AlertDialog alert = AlertDialog(
            title: Text(name + ' ($symbol)'),
            backgroundColor: Colors.blue.shade50,
            content: Text(sectorName),
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
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Text(type,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400))
              ],
            ),
            Spacer(),
            Column(
              children: <Widget>[
                Text('Rs 410',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
      ),
    );
  }
}
