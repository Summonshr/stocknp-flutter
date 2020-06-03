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
              Spacer(),
              if (items.length > 0)
                Text('Rs. ' +
                    items
                        .map((TotalBought item) => item.total * item.per)
                        .reduce((value, element) => value + element)
                        .toInt()
                        .toString())
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              if (items.length > 0)
                Text('Total: ' +
                    (items
                            .map((TotalBought item) => item.total)
                            .reduce((value, element) => value + element))
                        .toString() +
                    ' kitta'),
              if (items.length > 0)
                Text(' @ Rs. ' +
                    (items
                                .map((TotalBought item) => item.per)
                                .reduce((value, element) => value + element) /
                            items.length)
                        .toStringAsFixed(2)),
              Spacer(),
              if (items.length > 0) Text(percentage().toStringAsFixed(2) + "%")
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Actions'),
                      )
                    ]),
                ...items
                    .map((TotalBought item) => item.editWidget(context, () {
                          setState(() {
                            quantity = item.total;
                            boughtAt = item.per;
                          });
                          totalBought(context, item: item);
                        }, () {
                          items.removeWhere(
                              (TotalBought t) => t.hashCode == item.hashCode);
                          setState(() {
                            items = items;
                          });
                        }))
                    .toList()
              ],
            ),
          ),
        if (expanded)
          FlatButton(
              onPressed: () {
                totalBought(context);
              },
              child: Text("Add"))
      ],
    );
  }

  void totalBought(BuildContext context, {TotalBought item}) {
    AlertDialog dialog = AlertDialog(
      title: Text((item != null ? 'Update ' : 'Add ') + widget.name + " stock"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              if (quantity != null && boughtAt != null) {
                if (item == null) {
                  List<TotalBought> itms = items;
                  itms.add(TotalBought(total: quantity, per: boughtAt));
                  setState(() {
                    items = itms;
                    quantity = null;
                    boughtAt = null;
                  });
                } else {
                  List itms = items.map((TotalBought e) {
                    if (e.hashCode == item.hashCode) {
                      e.total = quantity;
                      e.per = boughtAt;
                    }
                    return e;
                  }).toList();
                  setState(() {
                    items = itms;
                  });
                }

                Navigator.of(context).pop();
              }
            },
            child: Text(item != null ? 'Update' : 'Add',
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
            initialValue: item != null ? item.total.toString() : null,
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
            initialValue: item != null ? item.per.toString() : null,
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
