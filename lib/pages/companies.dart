import 'dart:convert';

import 'package:StockNp/components/drawer.dart';
import 'package:flutter/material.dart';
import '../requests/requests.dart';
import '../models/company.dart';

class Companies extends StatefulWidget {
  Companies({Key key}) : super(key: key);

  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  String html;

  List<Company> companies = [];

  List<String> types = ['All'];

  String activeType = 'All';

  @override
  void initState() {
    super.initState();
    getCompanies().then((data) {
      companies = [];
      types = ['All'];
      for (Map i in jsonDecode(data.body)) {
        companies.add(Company.fromJson(i));
        types.add(i['sector_name']);
      }

      setState(() {
        companies = companies;
        types = types.toSet().toList();
      });
    });
    print('was called');
  }

  @override
  Widget build(BuildContext context) {
    List filtered = companies
        .where((Company company) =>
            activeType == 'All' || activeType == company.sectorName)
        .toList();
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.grey.shade900, size: 25.0),
          elevation: 0.0, // Removes background
          title:
              Text("Demo app", style: TextStyle(color: Colors.grey.shade800)),
          actions: <Widget>[],
        ),
        body: SafeArea(
          child: Container(
              child: Column(
            children: <Widget>[
              SingleChildScrollView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    ...types
                        .map((String type) => FlatButton(
                            color: activeType == type
                                ? Colors.grey.shade300
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            onPressed: () {
                              setState(() {
                                activeType = type;
                              });
                            },
                            child: Text(type.toUpperCase())))
                        .toList(),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      return filtered[index].toList(context);
                    }),
              )
            ],
          )),
        ));
  }
}
