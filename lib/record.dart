import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String Name;
  final String LiveURL;
  final bool Live;
  final Timestamp CreatedAt;
  final String Desc;
  final int Votes;
  final List<String> URLs;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['CreatedAt'] != null),
        assert(map['LiveURL'] != null),
        assert(map['Live'] != null),
        // assert(map['SavedURL'] != null),
        assert(map['Votes'] != null),
        assert(map['Desc'] != null),
        Name = map['Name'],
        CreatedAt = map['CreatedAt'],
        LiveURL = map['LiveURL'],
        Live = map['Live'],
        Votes = map['Votes'],
        Desc = map['Desc'],
        //URLs = new List<String>.from(map['URLs']);
        URLs = map['URLs'] != null ? new List<String>.from(map['URLs']) : [];
  // OtherURLs = map['OtherURLs'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$Name:$Votes>";
}
