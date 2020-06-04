import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/user.dart';
import 'package:StockNp/requests/requests.dart';
import 'package:StockNp/storage/companies.dart';
import 'package:StockNp/storage/user.dart';
import 'package:flutter/material.dart';
import './pages/single.dart';
import './pages/tag.dart';
import './pages/companies.dart';
import './pages/home.dart';
import './pages/portfolio.dart';
import './storage/portfolio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

void boot() {
  InternetAddress.lookup('stocknp.com').then((List results) {
    if (results.isNotEmpty && results[0].rawAddress.isNotEmpty) {
      runApp(MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => PortfolioStorage()),
        ChangeNotifierProvider(create: (_) => CompanyStorage()),
        ChangeNotifierProvider(create: (_) => UserStorage()),
      ], child: StockNP()));
      return;
    }
  }).catchError((onError) {
    runApp(EnableInternet());
    Timer(Duration(seconds: 3), () {
      boot();
    });
  });
}

void main() {
  boot();
}

class EnableInternet extends StatelessWidget {
  const EnableInternet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
      child: Text('Internet Not Connected.'),
    )));
  }
}

class StockNP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User().signInWithGoogle().then((user) {
      context.read<UserStorage>().updateUser(user);
    }).catchError((error) {});

    getCompanies().then((data) {
      List<Company> companies = [];
      for (Map i in jsonDecode(data.body)) {
        companies.add(Company.fromJson(i));
      }
      context.read<CompanyStorage>().data(companies: companies);
    }).catchError((err) {
      print(err);
      print('Companies not loaded');
    });
    return MaterialApp(initialRoute: 'home', routes: {
      'home': (context) => App(),
      'tag': (context) => Tag(),
      'single': (context) => Single(),
      'portfolio': (context) => Portfolio(),
      'companies': (context) => Companies(),
    });
  }
}
