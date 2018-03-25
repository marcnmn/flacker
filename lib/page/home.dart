import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';
import 'package:tracker/model/period.dart';
import 'package:tracker/page/login.dart';
import 'dart:async';
import 'package:tracker/service/auth.dart';
import 'package:tracker/service/storage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  AnimationController loadCtrl;
  Animation<double> loadAnim;

  String _workTitle = 'Heute gearbeitet';
  String _workDuration = '00:00:00';

  Periods _periods = new Periods('', '');
  Period _current;
  String _userId = 'marc-123';
  FirebaseUser _user;

  final AuthHandler authHandler = new AuthHandler();
  final StorageService storage = new StorageService();

  bool _saved = true;

  static const _startBtnStart = 'Start 😖';
  static const _startBtnCtn = 'Weiter 😩';
  static const _pauseBtn = 'Pause 🎉';
  static const _saveBtn = 'Speichern 💾';
  static const _animDur = const Duration(milliseconds: 500);
  static const _loadDur = const Duration(milliseconds: 250);

  static const _workBkg = 'images/background_pattern.png';
  static const _pauseBkg = 'images/background_pattern_pause.png';

  initState() {
    super.initState();
    controller = new AnimationController(duration: _animDur, vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
    animation.addListener(() => setState(() => {}));

    loadCtrl = new AnimationController(duration: _loadDur, vsync: this);
    loadAnim = new Tween(begin: 0.0, end: 1.0).animate(loadCtrl);
    loadAnim.addListener(() => setState(() => {}));

    _runClock();
    _setup();
  }

  void _navigateLogin() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new LoginPage()));
  }

  _setup() async {
    _user = await authHandler.currentUser;
    if (_user == null) _navigateLogin();
    _periods = await storage.getToday(_user.uid);
    setState(() => {});
    loadCtrl.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  void _start() {
    _current = new Period.start();
    controller.forward();
    _saved = false;
  }

  void _pause() {
    if (_current == null || _current.x == null) return;
    _current.y = new DateTime.now();
    _periods.data.add(_current);
    controller.reverse();
    _current = null;
    _updateDate();
  }

  Future<Null> _saveDay() async {
    if (_periods.data.length <= 0 || _current != null) return;
    await storage.setToday(_periods);
    _updateDate();
    _saved = true;
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
      _periods.data.forEach((p) => duration += p.duration);
      _workDuration = Period.durationToString(duration);
    });
  }

  String get _startLabel =>
      _periods.data.isEmpty ? _startBtnStart : _startBtnCtn;
  // String get _userLabel => _user != null ? _user.displayName : '';
  String get _imageLabel => _current != null ? '😖' : '🎉';
  get _startFn => _current?.x == null ? _start : null;
  get _pauseFn => _current?.x != null ? _pause : null;
  get _saveFn =>
      !_saved && _periods.data.isNotEmpty && _current == null ? _saveDay : null;

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
            new Opacity(
                opacity: loadAnim.value,
                child: new Center(
                  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(_imageLabel, textScaleFactor: 5.0),
                        new Container(height: 50.0),
                        new Text(_workTitle, textScaleFactor: 1.2),
                        // new Text(_userLabel, textScaleFactor: 1.4),
                        new Container(height: 0.0),
                        new Text(_workDuration, textScaleFactor: 4.0),
                        new Container(height: 50.0),
                        new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            fb(_startLabel, _startFn),
                            new Container(width: 20.0),
                            fb(_pauseBtn, _pauseFn),
                          ],
                        ),
                        new Container(height: 20.0),
                        fb(_saveBtn, _saveFn),
                      ]),
                )),
            new Opacity(
                opacity: 1 - loadAnim.value,
                child: new Center(child: new CircularProgressIndicator())),
          ],
        ));
  }
}

FlatButton fb(String l, VoidCallback fn) => new FlatButton(
    child: new Text(l, textScaleFactor: 1.25),
    padding: new EdgeInsets.all(15.0),
    onPressed: fn);

BoxDecoration _bkg(String asset) => new BoxDecoration(
        image: new DecorationImage(
      image: new AssetImage(asset),
      fit: BoxFit.scaleDown,
      repeat: ImageRepeat.repeat,
    ));
