import 'package:cloud_firestore/cloud_firestore.dart';

class Wheels {
  String? W1;
  String? W2;
  String? W3;
  String? W4;
}

class Sentiment {
  double? magnitude;
  double? score;
}

class Networks {
  String name;
  String URL;

  Networks({ required this.name, required this.URL});
}

class Record {
  final String _id;
  final String _name;
  final bool _live;
  final DateTime _createdAt;
  final String _desc;
  final String _imageURL;
  final int _votes;
  final List _networks;
  final Map _sentiment;
  final Map _wheels;

  final DocumentReference reference;

  Record(this._name, this._id, this._networks, this._live, this._createdAt, this._desc, this._imageURL, this._votes, this._wheels, this._sentiment, this.reference);

  Record.fromMap(Map<String, dynamic>? map, {required this.reference})
      : assert(map?['Name'] != null),
        assert(map?['CreatedAt'] != null),
        // assert(map['Network'] != null),
        assert(map?['Live'] != null),
        assert(map?['Votes'] != null),
        assert(map?['Desc'] != null),
        _id = reference.id,
        _name = map?['Name'],
        // _createdAt = map['createdAt'] as DateTime,
        _createdAt = (map?['CreatedAt'] as Timestamp).toDate(),
        _live = map?['Live'],
        _votes = map?['Votes'],
        _desc = map?['Desc'],
        _imageURL = map?['ImageURL'],
        _sentiment = map?['sentiment'],
        _wheels = map?['Wheels'],
        _networks = map?['Networks'] != null ? List<Map>.from(map?['Networks']) : [];

  Record.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
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
  Map get Wheels => _wheels;
  Map get Sentiment => _sentiment;

  @override
  String toString() => "Record<$_name:$_votes>";
}

