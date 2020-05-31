import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final String route;
  const CustomDrawer({Key key, this.route}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState(currentRoute: route);
}

class _CustomDrawerState extends State<CustomDrawer> {
  String currentRoute = 'home';

  _CustomDrawerState({Key key, this.currentRoute});

  void setCurrentRoute(String route) {
    setState(() {
      currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.pink.shade100),
            child: SafeArea(
              child: SizedBox(
                height: 90,
                child: DrawerHeader(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      child: Center(child: Image.asset('./images/logo.png')),
                    )),
              ),
            ),
          ),
          ListTile(
              contentPadding: EdgeInsets.only(left: 25.0),
              title: Text('Categories',
                  style: TextStyle(color: Colors.grey.shade900))),
          MenuItem(
            active: currentRoute == 'home',
            updateRoute: setCurrentRoute,
            title: 'Home',
            route: 'home',
            icon: Icons.account_balance_wallet,
          ),
          Divider(),
          ListTile(
              contentPadding: EdgeInsets.only(left: 25.0, bottom: 0),
              title: Text('Others',
                  style: TextStyle(color: Colors.grey.shade900))),
          MenuItem(
              active: currentRoute == 'companies',
              updateRoute: setCurrentRoute,
              title: 'Companies',
              route: 'companies',
              icon: Icons.calendar_today),
          Divider(),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;

  final String title;

  final Widget trailing;

  final String route;

  final Function updateRoute;

  final bool active;

  MenuItem({
    Key key,
    this.icon,
    this.title,
    this.active,
    this.route,
    this.updateRoute,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.popUntil(context, (given) {
            updateRoute(route);
            return true;
          });
          if (route == 'home') {
            Navigator.popUntil(context, ModalRoute.withName('home'));
            return;
          }
          Navigator.popUntil(context, ModalRoute.withName('home'));
          Navigator.of(context).pushNamed(route);
        },
        dense: true,
        leading:
            Icon(icon, color: active ? Colors.green : Colors.grey.shade700),
        trailing: trailing,
        contentPadding: EdgeInsets.only(left: 25.0, right: 15.0, top: 0.0),
        title: Text(title,
            style: TextStyle(
                color: active ? Colors.green : Colors.grey.shade900)));
  }
}
