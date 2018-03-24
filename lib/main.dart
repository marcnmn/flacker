import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
// import 'package:share/share.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  void _incrementCounter(String msg) {
    print(msg);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Welcome to Flutter', home: new StartStopPage());
  }
}

class StartStopPage extends StatefulWidget {
  StartStopPage({Key key}) : super(key: key);

  @override
  _StartStopPageState createState() => new _StartStopPageState();
}

class _StartStopPageState extends State<StartStopPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  String _title = 'yoyoy';
  String _background = _workBkg;
  var _model = [];
  DecorationTween _dt;
  bool _workMode = true;

  static const _startBtn = 'Start 😖';
  static const _pauseBtn = 'Pause 🎉';
  static const _saveBtn = 'Speichern 💾';

  static const _workBkg = 'images/background_pattern.png';
  static const _pauseBkg = 'images/background_pattern_pause.png';

  DateTime start = new DateTime.now();

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() => setState(() => {}));
    // todo: fetch from storage
    // _runClock();
    _model.add(new Period.start());
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  BoxDecoration _bkg(String asset) => new BoxDecoration(
          image: new DecorationImage(
        image: new AssetImage(asset),
        fit: BoxFit.scaleDown,
        repeat: ImageRepeat.repeat,
      ));

  void _incrementCounter(String msg) {
    // share(msg);
    setState(() {
      _title = msg;
    });
    _workMode = !_workMode;
    if (_workMode)
      controller.forward();
    else
      controller.reverse();
  }

  Period _current() => _model.last;

  void _runClock() async {
    final stream = new Stream.periodic(new Duration(seconds: 1));
    await for (var _ in stream) {
      _updateDate();
    }
  }

  void _updateDate() {
    setState(() {
      Duration diff = new DateTime.now().difference(start);
      _title = [
        diff.inHours.toString().padLeft(2, '0'),
        (diff.inMinutes % 60).toString().padLeft(2, '0'),
        (diff.inSeconds % 60).toString().padLeft(2, '0'),
      ].join(':');
      print(_current());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Track Your 🤬')),
        body: new Stack(
          children: <Widget>[
            new Opacity(
                opacity: animation.value,
                child: new Container(decoration: _bkg(_workBkg))),
            new Opacity(
                opacity: 1 - animation.value,
                child: new Container(decoration: _bkg(_pauseBkg))),
            new Center(
              child:
                  new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                new Text(_title, textScaleFactor: 4.0),
                new Container(height: 50.0),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new FlatButton(
                        child: const Text(_startBtn),
                        onPressed: () => _incrementCounter(_startBtn)),
                    new Container(width: 20.0),
                    new FlatButton(
                        child: const Text(_pauseBtn),
                        onPressed: () => _incrementCounter(_pauseBtn)),
                  ],
                ),
                new Container(height: 50.0),
                new FlatButton(
                    child: const Text(_saveBtn),
                    onPressed: () => _incrementCounter(_saveBtn)),
              ]),
            ),
          ],
        ));
  }
}

class Period {
  DateTime x, y;
  Period(this.x, this.y);

  Period.start() {
    this.x = new DateTime.now();
  }
}
