import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tracker/page/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final ThemeData kIOSTheme = new ThemeData(
    // primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );

  final ThemeData kDefaultTheme = new ThemeData(
      // primarySwatch: Colors.purple,
      // accentColor: Colors.orangeAccent[400],
      );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Welcome to Flutter',
        theme: defaultTargetPlatform == TargetPlatform.iOS
            ? kIOSTheme
            : kDefaultTheme,
        home: new HomePage());
  }
}
