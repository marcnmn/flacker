import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tracker/page/home.dart';
import 'package:tracker/service/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  FirebaseUser _user;
  final AuthHandler _authHandler = new AuthHandler();

  initState() {
    super.initState();
    _signIn();
  }

  Future<Null> _signIn() async {
    _user = await _authHandler.signIn();
    if (_user == null) {
      throw new Error();
    }
    _navigateHome();
  }

  void _navigateHome() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new HomePage(),
            settings: new RouteSettings(isInitialRoute: false)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Track Your 🤬 Work')),
        body: new Row(children: <Widget>[
          new Text('Login!!'),
          new FlatButton(child: new Text('go home'), onPressed: _navigateHome),
        ]));
  }
}
