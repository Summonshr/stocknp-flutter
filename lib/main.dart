import 'package:flutter/material.dart';
import './pages/single.dart';
import './pages/tag.dart';
import './pages/companies.dart';
import './pages/home.dart';

void main() {
  runApp(StockNP());
}

class StockNP extends StatelessWidget {
  const StockNP({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: 'companies', routes: {
      'home': (context) => App(),
      'tag': (context) => Tag(),
      'single': (context) => Single(),
      'companies': (context) => Companies(),
    });
  }
}
