import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/news.dart';
import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/models/total-bought.dart';
import 'package:StockNp/models/user.dart';
import 'package:StockNp/requests/requests.dart';
import 'package:StockNp/storage/companies.dart';
import 'package:StockNp/storage/file-storage.dart';
import 'package:StockNp/storage/news.dart';
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
import 'package:page_transition/page_transition.dart';

Future<List> hasInternet() {
  return InternetAddress.lookup('stocknp.com');
}

void boot() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PortfolioStorage()),
    ChangeNotifierProvider(create: (_) => CompanyStorage()),
    ChangeNotifierProvider(create: (_) => UserStorage()),
    ChangeNotifierProvider(create: (_) => NewsStorage()),
  ], child: StockNP()));
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
    Storage().read('news', (String data) {
      List<News> news = [];
      for (Map i in jsonDecode(data)) {
        news.add(News.fromJson(i));
      }
      print(news);

      context.read<NewsStorage>().load(news);
    });

    Storage().read('portfolios', (String data) {
      List<PortfolioItem> items = [];
      for (Map i in jsonDecode(data)) {
        items.add(PortfolioItem.fromJson(i));
      }
      context.read<PortfolioStorage>().loadPortfolios(items);
    });

    Storage().read('boughts', (data) {
      List<TotalBought> items = [];
      for (Map i in jsonDecode(data)) {
        items.add(TotalBought.fromJson(i));
      }
      context.read<PortfolioStorage>().loadBoughts(items);
    });
    hasInternet().then((results) {
      if (results.isEmpty) {
        return;
      }
      getCompanies().then((data) {
        List<Company> companies = [];
        for (Map i in jsonDecode(data.body)) {
          companies.add(Company.fromJson(i));
        }
        context.read<CompanyStorage>().data(companies: companies);
      }).catchError((err) {});
      User().signInWithGoogle().then((user) {
        context.read<UserStorage>().updateUser(user);
      }).catchError((error) {});
    }).catchError((error) {});

    return MaterialApp(initialRoute: 'home', routes: {
      'home': (context) => App(),
      'tag': (context) => Tag(),
      'single': (context) => Single(),
      'portfolio': (context) => Portfolio(),
      'companies': (context) => Companies(),
    });
  }
}
