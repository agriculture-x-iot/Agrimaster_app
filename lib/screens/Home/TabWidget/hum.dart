import 'package:cloud_firestore/cloud_firestore.dart';

class Sales {
  final int hum;
  final Timestamp date;
  Sales(this.hum,this.date);

  Sales.fromMap(Map<String, dynamic> map)
      : assert(map['hum'] != null),
        assert(map['date'] != null),
        hum = map['hum'],
        date = map['date'];

  @override
  String toString() => "Record<$hum:$date>";
}