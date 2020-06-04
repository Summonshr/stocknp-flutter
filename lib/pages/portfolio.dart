import 'package:StockNp/components/drawer.dart';
import 'package:StockNp/models/company.dart';
import 'package:StockNp/models/portfolio-item.dart';
import 'package:StockNp/storage/portfolio-storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  return user;
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: const Text('SIGN IN'),
                onPressed: () {
                  signInWithGoogle().then((FirebaseUser user) {
                    context.read<Items>().updateUser(user);
                  });
                },
              ),
            ],
          ),
        ));
  }
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = context.watch<Items>().currentUser;
    if (user == null) {
      return LoginPage();
    }
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
