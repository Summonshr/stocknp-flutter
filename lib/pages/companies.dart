import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/storage/companies.dart';
import 'package:flutter/material.dart';
import '../models/company.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class Companies extends StatefulWidget {
  Companies({Key key}) : super(key: key);

  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  String html;

  List<Company> companies = [];

  List<String> types = [];

  String activeType = '';

  List<String> filterList = [];

  List<String> filters = [];

  bool loaded = false;

  bool checked = false;

  bool orderByAsc = true;

  String orderBy = 'price';

  @override
  Widget build(BuildContext context) {
    List<Company> companies = context.watch<CompanyStorage>().companies;
    List<String> types = companies
        .map((Company company) => company.sectorName)
        .toList()
        .toSet()
        .toList();

    if (companies.length == 0) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    List<String> filters = companies
        .map((Company company) => company.type)
        .toList()
        .toSet()
        .toList();
    List<String> selectedFilters = context.watch<CompanyStorage>().filters;
    return DefaultTabController(
        length: types.length,
        child: Scaffold(
            drawer: CustomDrawer(route: 'companies'),
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme:
                    IconThemeData(color: Colors.grey.shade900, size: 25.0),
                elevation: 0.0, // Removes background
                title: Text("Companies",
                    style: TextStyle(color: Colors.grey.shade800)),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
                        AlertDialog dialog = AlertDialog(
                          title: Text('Filter list'),
                          contentPadding: EdgeInsets.all(10),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                ...filters.map((filter) => FilterList(
                                    checked: selectedFilters
                                            .where(
                                                (String type) => type == filter)
                                            .length >
                                        0,
                                    title: filter,
                                    callback: context
                                        .read<CompanyStorage>()
                                        .setFilter))
                              ],
                            ),
                          ),
                        );
                        showDialog(context: context, child: dialog);
                      }),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    onPressed: () {
                      setState(() {
                        orderBy = orderBy == 'price' ? 'eps' : 'price';
                        orderByAsc = !orderByAsc;
                      });
                    },
                  )
                ],
                bottom: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.grey.shade100,
                    indicator: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(25.0)),
                    tabs: [
                      ...types
                          .map((String type) => Tab(child: Text(type)))
                          .toList(),
                    ])),
            body: TabBarView(children: [
              ...types.map((String type) {
                List filtered = companies
                    .where((Company company) => type == company.sectorName)
                    .where((Company company) {
                  return selectedFilters
                          .where((String filter) => filter == company.type)
                          .length >
                      0;
                }).toList();

                filtered.sort((a, b) =>
                    (orderByAsc ? 1 : -1) * (b.price - a.price).round());

                return Container(
                    child: Column(
                  children: <Widget>[
                    filtered.length > 0
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return filtered[index].toList(context);
                                }))
                        : Card(
                            child: Container(
                                height: 50.0,
                                width: double.infinity,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.not_interested),
                                    Text('No data available')
                                  ],
                                )))),
                  ],
                ));
              }).toList()
            ])));
  }
}

class FilterList extends StatefulWidget {
  final Function callback;

  final String title;

  final bool checked;

  FilterList({Key key, this.callback, this.title, this.checked})
      : super(key: key);

  @override
  _FilterListState createState() =>
      _FilterListState(callback: callback, title: title, checked: checked);
}

class _FilterListState extends State<FilterList> {
  bool checked = false;

  Function callback;

  String title;

  _FilterListState({Key key, this.title, this.callback, this.checked});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
          value: checked,
          title: Text(title),
          onChanged: (value) {
            callback(title, value);
            setState(() {
              checked = !checked;
            });
          }),
    );
  }
}
