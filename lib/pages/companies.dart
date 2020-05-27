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

  List<String> types = [];

  String activeType = '';

  List<String> filterList = [];

  @override
  void initState() {
    super.initState();
    getCompanies().then((data) {
      companies = [];
      types = [];
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

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: types.length,
        child: Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme:
                    IconThemeData(color: Colors.grey.shade900, size: 25.0),
                elevation: 0.0, // Removes background
                title: Text("Companies",
                    style: TextStyle(color: Colors.grey.shade800)),
                actions: <Widget>[],
                bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.grey.shade100,
                    indicator: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(25.0)),
                    tabs: [
                      ...types
                          .map((String type) => Tab(child: Text(type)))
                          .toList(),
                    ])),
            body: TabBarView(children: [
              ...types.map((String type) {
                List filtered = companies
                    .where((Company company) => type == company.sectorName)
                    .toList();
                return Expanded(
                  child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (BuildContext context, int index) {
                        return filtered[index].toList(context);
                      }),
                );
              }).toList()
            ])));
  }
}
