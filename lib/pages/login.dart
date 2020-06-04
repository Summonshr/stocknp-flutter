import 'package:StockNp/models/user.dart';
import 'package:StockNp/storage/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('./images/logo.png'),
          ),
          SizedBox(
            height: 20,
          ),
          SignInButton(
            Buttons.Google,
            text: "Sign in with Google",
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
