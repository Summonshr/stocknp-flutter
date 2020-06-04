import 'package:StockNp/models/user.dart';
import 'package:StockNp/storage/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  User().signInWithGoogle().then((FirebaseUser user) {
                    context.read<UserStorage>().updateUser(user);
                  });
                },
              ),
            ],
          ),
        ));
  }
}
