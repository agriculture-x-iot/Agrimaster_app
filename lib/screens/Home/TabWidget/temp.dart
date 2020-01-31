import 'package:cloud_firestore/cloud_firestore.dart';

class Sales {
  final int tmp;
  final Timestamp date;
  Sales(this.tmp,this.date);

  Sales.fromMap(Map<String, dynamic> map)
      : assert(map['tmp'] != null),
        assert(map['date'] != null),
        tmp = map['tmp'],
        date = map['date'];

  @override
  String toString() => "Record<$tmp:$date>";
}