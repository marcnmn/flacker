import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/model/period.dart';
import 'package:tracker/service/common.dart';

class StorageService {
  final String _userCol = 'users';
  final String _periodCol = 'period';

  Future<QuerySnapshot> getAll(String uid) {
    return Firestore.instance
        .collection(_periodCol)
        .where('userId', isEqualTo: uid)
        .getDocuments();
  }

  Future<Periods> getToday(String uid) {
    String dk = PeriodUtils.dateToStorageKey(new DateTime.now());
    return _getDay(uid, dk);
  }

  Future<Periods> _getDay(String uid, String key) async {
    DocumentSnapshot ds = await Firestore.instance
        .collection(_periodCol)
        .document(_createKey(uid, key))
        .get()
        .catchError((e) => print(e));

    if (!ds.exists) return new Periods(uid, key);
    Periods p = new Periods(ds.data['uid'], ds.data['date']);

    var data = ds.data['data'];
    if (!(data is List)) return p;
    data.forEach((e) {
      if (e is LinkedHashMap) {
        DateTime x = e['x'] is DateTime ? e['x'] : null;
        DateTime y = e['y'] is DateTime ? e['y'] : null;
        p.data.add(new Period(x, y));
      }
    });
    return p;
  }

  Future<bool> setToday(Periods p) async {
    Firestore.instance
        .collection(_periodCol)
        .document(_createKey(p.userId, p.date))
        .setData(p.toMap())
        .catchError((e) => print(e));
  }

  String _createKey(String uid, String key) => '${uid}_$key';
}
