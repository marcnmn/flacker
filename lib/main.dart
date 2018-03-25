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
  AnimationController controller;
  Animation<double> animation;

  String _workTitle = 'Heute gearbeitet';
  String _workDuration = '00:00:00';

  List<Period> _periods = [];
  Period _current;

  static const _startBtnStart = 'Start 😖';
  static const _startBtnCtn = 'Weiter 😩';
  static const _pauseBtn = 'Pause 🎉';
  static const _saveBtn = 'Speichern 💾';
  static const _animDur = const Duration(milliseconds: 500);

  static const _workBkg = 'images/background_pattern.png';
  static const _pauseBkg = 'images/background_pattern_pause.png';

  initState() {
    super.initState();
    controller = new AnimationController(duration: _animDur, vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
    animation.addListener(() => setState(() => {}));
    _runClock();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  void _start() {
    _current = new Period.start();
    controller.forward();
  }

  void _pause() {
    if (_current == null || _current.x == null) return;
    _current.y = new DateTime.now();
    _periods.add(_current);
    controller.reverse();
    _current = null;
  }

  void _saveDay() {
    if (_periods.length <= 0 || _current != null) return;
    // todo: save action
    print('saveDay');
    _periods.clear();
    _current = null;
    _updateDate();
  }

  void _runClock() async {
    final stream = new Stream.periodic(new Duration(seconds: 1));
    await for (var _ in stream) {
      _updateDate();
    }
  }

  void _updateDate() {
    setState(() {
      Duration duration = _current != null ? _current.duration : new Duration();
      _periods.forEach((p) => duration += p.duration);
      _workDuration = Period.durationToString(duration);
    });
  }

  String get _startLabel => _periods.isEmpty ? _startBtnStart : _startBtnCtn;
  get _startFn => _current?.x == null ? _start : null;
  get _pauseFn => _current?.x != null ? _pause : null;
  get _saveFn => _periods.isNotEmpty && _current == null ? _saveDay : null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Track Your 🤬 Work')),
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
                new Text(_workTitle, textScaleFactor: 1.4),
                new Container(height: 10.0),
                new Text(_workDuration, textScaleFactor: 4.0),
                new Container(height: 50.0),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new FlatButton(
                        child: new Text(_startLabel, textScaleFactor: 1.25),
                        onPressed: _startFn),
                    new Container(width: 20.0),
                    new FlatButton(
                        child: const Text(_pauseBtn, textScaleFactor: 1.25),
                        onPressed: _pauseFn),
                  ],
                ),
                new Container(height: 50.0),
                new FlatButton(
                    child: const Text(_saveBtn, textScaleFactor: 1.25),
                    onPressed: _saveFn),
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

  Duration get duration {
    if (this.x == null) return new Duration();
    if (this.y == null) return new DateTime.now().difference(this.x);
    return this.y.difference(this.x);
  }

  static String durationToString(Duration dur) {
    return [
      dur.inHours.toString().padLeft(2, '0'),
      (dur.inMinutes % 60).toString().padLeft(2, '0'),
      (dur.inSeconds % 60).toString().padLeft(2, '0'),
    ].join(':');
  }
}

BoxDecoration _bkg(String asset) => new BoxDecoration(
        image: new DecorationImage(
      image: new AssetImage(asset),
      fit: BoxFit.scaleDown,
      repeat: ImageRepeat.repeat,
    ));
