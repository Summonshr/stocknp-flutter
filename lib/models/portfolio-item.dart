import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/total-bought.dart';
import 'package:StockNp/storage/companies.dart';
import 'package:StockNp/storage/portfolio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class PortfolioItem extends StatefulWidget {
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  PortfolioItem.fromJson(Map<String, dynamic> json) : name = json['name'];

  PortfolioItem({@required this.name});

  @override
  _PortfolioItemState createState() => _PortfolioItemState();
}

class _PortfolioItemState extends State<PortfolioItem> {
  bool expanded = false;

  double percentage() {
    List<TotalBought> items = context
        .watch<PortfolioStorage>()
        .totalBoughts
        .where((TotalBought item) => item.name == widget.name)
        .toList();

    if (items.length == 0) {
      return 0.0;
    }

    return items
        .map(
            (TotalBought item) => item.profitPercentageIfSoldAt(currentPrice()))
        .reduce((value, element) => value + element);
  }

  double currentPrice() {
    List<Company> companies = context.watch<CompanyStorage>().companies;
    return companies
        .firstWhere((Company company) => company.symbol == widget.name)
        .price;
  }

  int quantity;

  double boughtAt;

  @override
  Widget build(BuildContext context) {
    List<TotalBought> totalBoughts = context
        .watch<PortfolioStorage>()
        .totalBoughts
        .where((TotalBought company) => company.name == widget.name)
        .toList();
    return Column(
      children: <Widget>[
        ListTile(
          onLongPress: () {
            AlertDialog dialog = AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                      onTap: () {},
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15.0),
                          child: Text("Delete this entry")))
                ],
              ),
            );
            showDialog(context: context, child: dialog);
          },
          selected: expanded,
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (totalBoughts.length > 0) ...[
                SizedBox(
                  height: 5,
                ),
                Text('Rs. ' +
                    totalBoughts
                        .map((TotalBought item) => item.totalCost())
                        .reduce((value, element) => value + element)
                        .toInt()
                        .toString()),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  child: Text(percentage().toStringAsFixed(2) + "%",
                      style: TextStyle(fontSize: 10.0, color: Colors.white)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: percentage() > 0 ? Colors.green : Colors.red),
                )
              ]
            ],
          ),
          title: Row(
            children: <Widget>[
              Text.rich(TextSpan(text: widget.name + ": ", children: [
                TextSpan(
                    style: TextStyle(fontSize: 12.0),
                    text: 'Rs. ' + currentPrice().toStringAsFixed(2))
              ])),
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              if (totalBoughts.length > 0)
                Text.rich(
                  TextSpan(
                      text: (totalBoughts
                                  .map((TotalBought item) => item.total)
                                  .reduce((value, element) => value + element))
                              .toString() +
                          ' kitta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: ' @ ',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                            text: (totalBoughts
                                        .map((TotalBought item) =>
                                            item.totalCost())
                                        .reduce((value, element) =>
                                            value + element) /
                                    totalBoughts
                                        .map((TotalBought item) => item.total)
                                        .reduce((value, element) =>
                                            value + element))
                                .toStringAsFixed(2))
                      ]),
                ),
              Spacer(),
            ],
          ),
        ),
        if (expanded && totalBoughts.length > 0)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.purple.shade100),
              children: [
                TableRow(
                    decoration: BoxDecoration(color: Colors.purple.shade100),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Quantity'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Price'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Total'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Actions'),
                      )
                    ]),
                ...totalBoughts
                    .map((TotalBought item) => item.editWidget(context, () {
                          setState(() {
                            quantity = item.total;
                            boughtAt = item.per;
                          });
                          totalBought(context, item: item);
                        }, () {
                          context
                              .read<PortfolioStorage>()
                              .removeBought(item.hashCode);
                        }))
                    .toList()
              ],
            ),
          ),
        if (expanded)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blueGrey.shade100)),
                  color: Colors.blueGrey.shade100,
                  onPressed: () {
                    totalBought(context, item: TotalBought(name: widget.name));
                  },
                  child: Text.rich(WidgetSpan(
                      child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        maxRadius: 10,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.add,
                          size: 12.0,
                        ),
                      ),
                      Text(
                        ' Add',
                        style: TextStyle(color: Colors.blueGrey.shade900),
                      )
                    ],
                  )))),
              SizedBox(width: 10),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red.shade100)),
                  color: Colors.red.shade100,
                  onPressed: () {
                    setState(() {
                      expanded = false;
                    });
                  },
                  child: Text.rich(WidgetSpan(
                      child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        maxRadius: 10,
                        child: Icon(
                          Icons.close,
                          size: 12.0,
                        ),
                      ),
                      Text(
                        ' Close',
                        style: TextStyle(color: Colors.red.shade900),
                      )
                    ],
                  )))),
              SizedBox(width: 10),
            ],
          )
      ],
    );
  }

  void totalBought(BuildContext context, {@required TotalBought item}) {
    AlertDialog dialog = AlertDialog(
      title: Text(
          (item.total != null ? 'Update ' : 'Add ') + widget.name + " stock"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (quantity != null && boughtAt != null) {
                item.total = quantity;
                item.per = boughtAt;
                context.read<PortfolioStorage>().updateBoughts(item);
                setState(() {
                  quantity = null;
                  boughtAt = null;
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(item.total != null ? 'Update' : 'Add',
                style: TextStyle(color: Colors.blue))),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey))),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: item.total != null ? item.total.toString() : null,
            onChanged: (value) {
              setState(() {
                quantity = int.tryParse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
          ),
          TextFormField(
            initialValue: item.total != null ? item.per.toString() : null,
            onChanged: (value) {
              setState(() {
                boughtAt = double.tryParse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Bought At?',
            ),
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
          ),
        ],
      ),
    );
    showDialog(context: context, child: dialog);
  }
}
