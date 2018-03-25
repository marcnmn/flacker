class Periods {
  final String userId;
  String date;
  List<Period> data = [];

  Periods(this.userId, this.date);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'uid': this.userId, 'date': this.date};
    List<Map<String, DateTime>> dmap = [];
    this.data.forEach((p) => dmap.add({'x': p.x, 'y': p.y}));
    map['data'] = dmap;
    return map;
  }
}

class Period {
  DateTime x, y;

  Period(this.x, this.y);

  Period.start() {
    final DateTime now = new DateTime.now();
    this.x = now;
  }

  Duration get duration {
    if (this.x == null) return new Duration();
    if (this.y == null) return new DateTime.now().difference(this.x);
    return this.y.difference(this.x);
  }

  Map<String, String> toMap() {
    var m = new Map();
    m['x'] = this.x.toIso8601String();
    m['y'] = this.y.toIso8601String();
    return m;

    // {'x': this.x.toIso8601String(), 'y': this.y.toIso8601String()};
  }

  static String durationToString(Duration dur) {
    return [
      dur.inHours.toString().padLeft(2, '0'),
      (dur.inMinutes % 60).toString().padLeft(2, '0'),
      (dur.inSeconds % 60).toString().padLeft(2, '0'),
    ].join(':');
  }
}
