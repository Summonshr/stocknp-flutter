import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/total-bought.dart';
import 'package:flutter/material.dart';

class PortfolioItem extends StatefulWidget {
  final String name;
  final Company company;

  PortfolioItem({@required this.name, this.company});

  @override
  _PortfolioItemState createState() => _PortfolioItemState();
}

class _PortfolioItemState extends State<PortfolioItem> {
  bool expanded = false;

  List<TotalBought> items = [];
  String current;

  double percentage() {
    return 1.1;
  }

  double total() {
    return 0.0;
  }

  double currentPrice() {
    return widget.company.price;
  }

  int quantity;

  double boughtAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          title: Row(
            children: <Widget>[
              Text(widget.name),
              Text(currentPrice().toStringAsFixed(2)),
              Spacer(),
              Text(total().toStringAsFixed(2))
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              Text('Total: Rs. ' + 0.0.toString()),
              Text(' Bought at: Rs. ' + 0.0.toStringAsFixed(2)),
              Spacer(),
              Text(percentage().toStringAsFixed(2) + "%")
            ],
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(),
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
                        child: Text('Bought at'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Total'),
                      )
                    ]),
                ...items
                    .map((TotalBought item) => item.editWidget(context))
                    .toList()
              ],
            ),
          ),
        if (expanded)
          FlatButton(
              onPressed: () {
                AlertDialog dialog = AlertDialog(
                  title: Text("Add " + widget.name + " stock"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: quantity != null && boughtAt != null
                            ? () {
                                if (quantity != null && boughtAt != null) {
                                  List<TotalBought> itms = items;
                                  itms.add(TotalBought(
                                      total: quantity, per: boughtAt));
                                  setState(() {
                                    items = itms;
                                    quantity = null;
                                    boughtAt = null;
                                  });
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        child: Text('Add',
                            style: TextStyle(
                                color: quantity == null && boughtAt == null
                                    ? Colors.grey
                                    : Colors.blue))),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel',
                            style: TextStyle(color: Colors.grey))),
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            quantity = int.tryParse(value);
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            boughtAt = double.tryParse(value);
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Bought At?',
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                      ),
                    ],
                  ),
                );
                showDialog(context: context, child: dialog);
              },
              child: Text("Add"))
      ],
    );
  }
}
