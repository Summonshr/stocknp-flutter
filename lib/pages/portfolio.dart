import 'dart:convert';

import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/portfolio-item.dart';
import 'package:flutter/material.dart';
import 'package:StockNp/requests/requests.dart';

class Portfolio extends StatefulWidget {
  Portfolio({Key key}) : super(key: key);

  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  List<Company> companies = [];

  bool loaded = false;

  List<PortfolioItem> portfolios = [];

  @override
  void initState() {
    super.initState();
    getCompanies().then((data) {
      companies = [];
      loaded = false;
      for (Map i in jsonDecode(data.body)) {
        companies.add(Company.fromJson(i));
      }

      setState(() {
        companies = companies;
        loaded = true;
      });
    }).catchError((err) {
      print('Companies not loaded');
    });
  }

  void insertIntoList(String name) {
    List p = portfolios;

    p.add(PortfolioItem(
        name: name,
        company:
            companies.firstWhere((Company company) => company.symbol == name)));

    setState(() {
      portfolios = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(route: 'portfolio'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AlertDialog dialog = AlertDialog(
            contentPadding: EdgeInsets.all(0),
            title: Text("Choose a stock"),
            content: Container(
              width: 150,
              height: MediaQuery.of(context).size.height / 1.2,
              child: ListView.builder(
                padding: EdgeInsets.all(12.0),
                itemCount: companies.length,
                itemBuilder: (BuildContext context, int index) {
                  Company company = companies[index];
                  return ListTile(
                    title: Text(company.symbol),
                    onTap: () {
                      insertIntoList(company.symbol);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          );
          showDialog(context: context, child: dialog);
        },
        child: Icon(Icons.add),
      ),
      // drawer: CustomDrawer(route: 'portfolio'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.grey.shade900, size: 25.0),
        elevation: 0.0, // Removes background
        title:
            Text("My Portfolio", style: TextStyle(color: Colors.grey.shade800)),
        actions: <Widget>[],
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[...portfolios],
            ),
          )
        ],
      )),
    );
  }
}
