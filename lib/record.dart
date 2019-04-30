import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String Name;
  final String LiveURL;
  final String SavedURL;
  final bool Live;
  final Timestamp CreatedAt;
  final String Desc;
  final int Votes;
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
        SavedURL = map['SavedURL'],
        Votes = map['Votes'],
        Desc = map['Desc'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$Name:$Votes>";
}
