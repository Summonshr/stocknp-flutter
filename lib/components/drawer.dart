import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key key}) : super(key: key);

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
            title: 'Home',
            route: 'home',
            icon: Icons.account_balance_wallet,
          ),
          MenuItem(title: "Latest", icon: Icons.euro_symbol),
          Divider(),
          ListTile(
              contentPadding: EdgeInsets.only(left: 25.0, bottom: 0),
              title: Text('Others',
                  style: TextStyle(color: Colors.grey.shade900))),
          MenuItem(title: "Analysis", icon: Icons.fastfood),
          MenuItem(
              title: 'Companies',
              route: 'companies',
              icon: Icons.calendar_today),
          MenuItem(title: 'Opinions', icon: Icons.share),
          MenuItem(title: 'Rate Us', icon: Icons.star),
          Divider(),
          MenuItem(title: 'Log Out', icon: Icons.do_not_disturb),
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

  MenuItem({
    Key key,
    this.icon,
    this.title,
    this.route,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          if (route == 'home') {
            Navigator.popUntil(context, ModalRoute.withName('home'));
            return;
          }
          print(route);
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(route);
        },
        dense: true,
        leading: Icon(icon),
        trailing: trailing,
        contentPadding: EdgeInsets.only(left: 25.0, right: 15.0, top: 0.0),
        title: Text(title, style: TextStyle(color: Colors.grey.shade900)));
  }
}
