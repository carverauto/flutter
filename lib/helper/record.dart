import 'package:cloud_firestore/cloud_firestore.dart';

class Networks {
  String name;
  String URL;

  Networks({ this.name, this.URL});
}

class Record {
  final String _id;
  final String _name;
  final bool _live;
  final DateTime _createdAt;
  final String _desc;
  final String _imageURL;
  int _votes;
  final List _networks;

  DocumentReference reference;

  Record(this._name, this._id, this._networks, this._live, this._createdAt,
      this._desc, this._imageURL, this._votes, this.reference);

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['CreatedAt'] != null),
        // assert(map['Network'] != null),
        assert(map['Live'] != null),
        assert(map['Votes'] != null),
        assert(map['Desc'] != null),
        assert(map['ImageURL'] != null),
        _id = reference.id,
        _name = map['Name'],
        // _createdAt = map['createdAt'] as DateTime,
        _createdAt = (map['CreatedAt'] as Timestamp).toDate(),
        _live = map['Live'],
        _votes = map['Votes'],
        _desc = map['Desc'],
        _imageURL = map['ImageURL'],
        _networks = map['Networks'] != null ? new List<Map>.from(map['Networks']) : [];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  String get ID => _id;
  String get Name => _name;
  DateTime get CreatedAt => _createdAt;
  // Timestamp get createdAt => _createdAt;
  // Object get Network => _network;
  bool get Live => _live;
  int get Votes => _votes;
  String get Desc => _desc;
  String get ImageURL => _imageURL;
  List get Networks => _networks;

  @override
  String toString() => "Record<$_name:$_votes>";
}
