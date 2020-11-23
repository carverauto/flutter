import 'package:cloud_firestore/cloud_firestore.dart';

class URLs {
  String Network;
  String URL;
}

class Record {
  final String _name;
  int _ID;
  final String _url;
  final bool _live;
  // final Timestamp _createdAt;
  final DateTime _createdAt;
  final String _desc;
  int _votes;
  final List _urls;

  DocumentReference reference;

  Record(this._name, this._ID, this._url, this._live, this._createdAt, this._desc,
      this._votes, this._urls, this.reference);

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['ID'] != null),
        assert(map['CreatedAt'] != null),
        assert(map['URL'] != null),
        assert(map['Live'] != null),
        assert(map['Votes'] != null),
        assert(map['Desc'] != null),
        _name = map['Name'],
        _ID = map['ID'],
        // _createdAt = map['createdAt'] as DateTime,
        _createdAt = (map['CreatedAt'] as Timestamp).toDate(),
        _url = map['URL'],
        _live = map['Live'],
        _votes = map['Votes'],
        _desc = map['Desc'],
        _urls = map['URLs'] != null ? new List<Map>.from(map['URLs']) : [];

  // OtherURLs = map['OtherURLs'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  String get Name => _name;
  DateTime get CreatedAt => _createdAt;
  // Timestamp get createdAt => _createdAt;
  String get URL => _url;
  bool get Live => _live;
  int get Votes => _votes;
  String get Desc => _desc;
  List get urls => _urls;

  @override
  String toString() => "Record<$_name:$_votes>";
}
