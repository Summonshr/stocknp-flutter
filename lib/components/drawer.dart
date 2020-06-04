import 'package:StockNp/storage/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    FirebaseUser user = context.watch<UserStorage>().currentUser;
    return Drawer(
      child: Column(
        children: <Widget>[
          user != null
              ? Container(
                  decoration: BoxDecoration(color: Colors.deepPurple.shade900),
                  child: SafeArea(
                    child: SizedBox(
                      height: 90,
                      child: DrawerHeader(
                        padding: EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl)
                                : Image(image: AssetImage('./images/logo.png')),
                          ),
                          title: Text(user.displayName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey.shade400)),
                          subtitle: Text('Member',
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.grey.shade400)),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.pink.shade100),
                  child: SafeArea(
                    child: SizedBox(
                      height: 90,
                      child: DrawerHeader(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            child:
                                Center(child: Image.asset('./images/logo.png')),
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
          MenuItem(
              active: currentRoute == 'portfolio',
              updateRoute: setCurrentRoute,
              title: 'Portfolio',
              route: 'portfolio',
              icon: Icons.portrait),
          Divider(),
          MenuItem(
              onTap: () {
                Navigator.of(context).pop();
                AlertDialog dialog = AlertDialog(
                  content: Text(
                      'Stock NP is a progressing app meaning we are continuously adding features as seen needed or suitable according to the market.',
                      style: TextStyle(height: 1.7)),
                  title: Text('Stock NP'),
                );
                showDialog(context: context, child: dialog);
              },
              title: 'About Us',
              icon: Icons.info),
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

  final Function onTap;

  MenuItem(
      {Key key,
      this.icon,
      this.title,
      this.active = false,
      this.route,
      this.updateRoute,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap ??
            () {
              if (active) {
                // If current do not open again
                Navigator.of(context).pop();
                return;
              }

              Navigator.popUntil(context, (given) {
                updateRoute(route);
                return true;
              });
              Navigator.popUntil(context, ModalRoute.withName('home'));
              if (route == 'home') {
                return;
              }
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
