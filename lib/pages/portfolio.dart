import 'package:StockNp/pages/login.dart';
import 'package:StockNp/storage/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/storage/companies.dart';
import 'package:StockNp/storage/portfolio.dart';
import 'package:StockNp/storage/user.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = context.watch<UserStorage>().currentUser;
    if (user == null) {
      return LoginPage();
    }
    List<PortfolioItem> portfolios =
        context.watch<PortfolioStorage>().portfolios;

    List<Company> companies = context
        .watch<CompanyStorage>()
        .companies
        .where((Company company) =>
            portfolios
                .where((PortfolioItem item) => item.name == company.symbol)
                .toList()
                .length ==
            0)
        .toList();
    return Scaffold(
      drawer: CustomDrawer(),
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
                      context
                          .read<PortfolioStorage>()
                          .insertPortfolio(PortfolioItem(
                            name: company.symbol,
                          ));
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: context.watch<SettingsStorage>().headline1, size: 25.0),
        elevation: 0.0, // Removes background
        title: Text("My Portfolio",
            style:
                TextStyle(color: context.watch<SettingsStorage>().headline1)),
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
