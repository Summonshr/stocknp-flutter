import 'package:StockNp/models/total-bought.dart';
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
    List<TotalBought> boughts = context.watch<PortfolioStorage>().totalBoughts;
    double investment = 0.0;
    int quantity = 0;
    double sellAt = 0.0;
    double profitPercentage = 0.0;
    double profit = 0.0;
    if (boughts.length > 0) {
      investment = boughts.map((e) => e.actualCost()).reduce((a, b) => a + b);
      quantity = boughts.map((e) => e.total).reduce((a, b) => a + b);
      sellAt = boughts.map((e) => e.sellNow(context)).reduce((a, b) => a + b);
      profit = boughts
          .map((e) => e.profitIfSoldNow(context))
          .reduce((a, b) => a + b);
      profitPercentage = boughts
          .map((e) => e.profitPercentageIfSoldNow(context))
          .reduce((a, b) => a + b);
    }
    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNew(context, companies);
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
              children: <Widget>[
                if (portfolios.length == 0)
                  InkWell(
                    onTap: () {
                      addNew(context, companies);
                    },
                    child: Card(
                      color: Colors.purple,
                      margin: EdgeInsets.all(20.0),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Add a company',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                if (profit != 0) Divider(),
                if (profit != 0)
                  Card(
                      color: profit > 0
                          ? context.watch<SettingsStorage>().successColor
                          : context.watch<SettingsStorage>().dangerColor,
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text.rich(TextSpan(
                                text: "Total Investment: Rs. " +
                                    investment.toString())),
                            Text.rich(TextSpan(
                                text: "Total shares: " + quantity.toString())),
                            Text.rich(TextSpan(
                                text: "Current value: Rs. " +
                                    sellAt.toStringAsFixed(2))),
                            Text.rich(TextSpan(
                                text: "Total profit: Rs. " +
                                    profit.toStringAsFixed(2))),
                            Text.rich(TextSpan(
                                text: "Total profit %: " +
                                    profitPercentage.toStringAsFixed(2) +
                                    '%')),
                          ],
                        ),
                      )),
                Divider(height: 1),
                ...portfolios
              ],
            ),
          )
        ],
      )),
    );
  }

  void addNew(BuildContext context, List<Company> companies) {
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
                context.read<PortfolioStorage>().insertPortfolio(PortfolioItem(
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
  }
}
