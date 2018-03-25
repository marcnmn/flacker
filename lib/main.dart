import 'package:flutter/material.dart';
import 'package:tracker/page/home.dart';
import 'package:tracker/page/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Welcome to Flutter', home: new HomePage());
  }
}
