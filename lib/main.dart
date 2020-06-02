import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import './pages/single.dart';
import './pages/tag.dart';
import './pages/companies.dart';
import './pages/home.dart';
import './pages/portfolio.dart';

void boot() {
  InternetAddress.lookup('stocknp.com').then((List results) {
    if (results.isNotEmpty && results[0].rawAddress.isNotEmpty) {
      runApp(StockNP());
      return;
    }
  }).catchError((onError) {
    runApp(EnableInternet());
    Timer(Duration(seconds: 3), () {
      print('still not connected');
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
    return MaterialApp(initialRoute: 'home', routes: {
      'home': (context) => App(),
      'tag': (context) => Tag(),
      'single': (context) => Single(),
      'portfolio': (context) => Portfolio(),
      'companies': (context) => Companies(),
    });
  }
}
