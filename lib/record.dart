import 'package:cloud_firestore/cloud_firestore.dart';

class Urls {
  String network;
  String url;
}

class Record {
  final String _name;
  final String _url;
  final bool _live;
  // final Timestamp _createdAt;
  final DateTime _createdAt;
  final String _desc;
  final int _votes;
  final List _urls;

  DocumentReference reference;

  Record(this._name, this._url, this._live, this._createdAt, this._desc,
      this._votes, this._urls, this.reference);

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['createdAt'] != null),
        assert(map['url'] != null),
        assert(map['live'] != null),
        assert(map['votes'] != null),
        assert(map['desc'] != null),
        _name = map['name'],
        // _createdAt = map['createdAt'] as DateTime,
        _createdAt = (map['createdAt'] as Timestamp).toDate(),
        _url = map['url'],
        _live = map['live'],
        _votes = map['votes'],
        _desc = map['desc'],
        _urls = map['urls'] != null ? new List<Map>.from(map['urls']) : [];

  // OtherURLs = map['OtherURLs'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  String get name => _name;
  DateTime get createdAt => _createdAt;
  // Timestamp get createdAt => _createdAt;
  // Timestamp get createdAt => _createdAt;
  String get url => _url;
  bool get live => _live;
  int get votes => _votes;
  String get desc => _desc;
  List get urls => _urls;

  @override
  String toString() => "Record<$_name:$_votes>";
}
