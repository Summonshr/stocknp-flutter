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
    if (items.length == 0) {
      return 0.0;
    }
    return items
        .map((TotalBought item) =>
            item.profitPercentageIfSoldAt(widget.company.price))
        .reduce((value, element) => value + element);
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
          selected: expanded,
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (items.length > 0) ...[
                SizedBox(
                  height: 5,
                ),
                Text('Rs. ' +
                    items
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
                    text: 'Rs. ' + widget.company.price.toStringAsFixed(2))
              ])),
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              if (items.length > 0)
                Text.rich(
                  TextSpan(
                      text: (items
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
                            text: (items
                                        .map((TotalBought item) =>
                                            item.totalCost())
                                        .reduce((value, element) =>
                                            value + element) /
                                    items
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
        if (expanded && items.length > 0)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blueGrey.shade100)),
                  color: Colors.blueGrey.shade100,
                  onPressed: () {
                    totalBought(context);
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
