import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/storage/portfolio-storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Company> companies = context.watch<Items>().companies;
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
                      context.read<Items>().insertPortfolio(PortfolioItem(
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
              children: <Widget>[...context.watch<Items>().portfolios],
            ),
          )
        ],
      )),
    );
  }
}
