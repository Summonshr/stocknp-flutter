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

    List<TotalBought> boughts = context.watch<PortfolioStorage>().totalBoughts;
    double investment = 0.0;
    int quantity = 0;
    double sellAt = 0.0;
    double profitPercentage = 0.0;
    double profit = 0.0;
    if (boughts.length > 0) {
      investment = boughts.map((e) => e.totalCost()).reduce((a, b) => a + b);
      quantity = boughts.map((e) => e.total).reduce((a, b) => a + b);
      sellAt = boughts.map((e) => e.sellNow(context)).reduce((a, b) => a + b);
      profit = boughts
          .map((e) => e.profitIfSoldNow(context))
          .reduce((a, b) => a + b);
      profitPercentage = boughts
          .map((e) => e.profitPercentageIfSoldNow(context))
          .reduce((a, b) => a + b);
    }

    MaterialColor background = profit > 0 ? Colors.green : Colors.red;

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: context.watch<SettingsStorage>().headline1, size: 25.0),
        elevation: 0.0, // Removes background
        title: Text("My Portfolio",
            style:
                TextStyle(color: context.watch<SettingsStorage>().headline1)),
        actions: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
                color: Colors.blue.shade100,
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        titlePadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        contentPadding: EdgeInsets.all(0),
                        title: Text('Search for Company'),
                        content: AddNew(),
                      ));
                }),
          ),
          SizedBox(width: 20)
        ],
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          if (profit != 0) ...[
            Card(
                color: background.shade200,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text.rich(
                              TextSpan(
                                  text: "Total Investment: Rs. " +
                                      investment.toInt().toString()),
                              style: TextStyle(
                                  color: background.shade900.withAlpha(255),
                                  height: 1.7)),
                          Text.rich(
                              TextSpan(
                                  text: "Total shares: " + quantity.toString()),
                              style: TextStyle(
                                  color: background.shade900.withAlpha(255),
                                  height: 1.7)),
                          Text.rich(
                              TextSpan(
                                  text: "Current value: Rs. " +
                                      sellAt.abs().toInt().toString()),
                              style: TextStyle(
                                  color: background.shade900.withAlpha(255),
                                  height: 1.7)),
                          Text.rich(
                              TextSpan(
                                  text: "Total " +
                                      (profit > 0 ? 'profit' : 'loss') +
                                      ": Rs. " +
                                      profit.abs().toInt().toString()),
                              style: TextStyle(
                                  color: background.shade900.withAlpha(255),
                                  height: 1.7)),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                          minRadius: 35.0,
                          backgroundColor: background.shade900,
                          child: Text(profitPercentage.toStringAsFixed(2) + '%',
                              style: TextStyle(fontSize: 14.0)))
                    ],
                  ),
                )),
            Divider(
              endIndent: 0,
              indent: 0,
            ),
          ],
          Expanded(
            child: ListView(
              children: <Widget>[
                if (portfolios.length == 0)
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.all(0),
                            title: Text('Search for Company'),
                            content: AddNew(),
                          ));
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
                ...portfolios
              ],
            ),
          )
        ],
      )),
    );
  }
}

class AddNew extends StatefulWidget {
  AddNew({Key key}) : super(key: key);

  @override
  _AddNewState createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    List<Company> companies = context.watch<CompanyStorage>().companies;
    List<PortfolioItem> portfolios =
        context.watch<PortfolioStorage>().portfolios;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                filter = value;
              });
            },
            decoration: InputDecoration(hintText: 'Enter a search term'),
          ),
        ),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Builder(
              builder: (BuildContext context) {
                companies = companies.where((Company company) {
                  if (portfolios
                          .where((PortfolioItem item) =>
                              item.name == company.symbol)
                          .length >
                      0) {
                    return false;
                  }
                  if (filter != '') {
                    return company.symbol.contains(filter.toUpperCase());
                  }
                  return true;
                }).toList();

                return ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (BuildContext context, int index) {
                    Company company = companies[index];
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
