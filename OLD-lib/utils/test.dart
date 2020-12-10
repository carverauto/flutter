Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: _firebase.firebaseDB
            .reference()
            .child("chats")
            .child("nsbcalculator")
            .orderByChild('timestamp')
            .limitToFirst(15)
            .onValue,
        builder: (context, AsyncSnapshot<Event> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
          } else {

            if (snapshot.data.snapshot.value != null) {

                listMessage = Map.from(snapshot.data.snapshot.value)
                    .values
                    .toList()
                      ..sort(
                          (a, b) => a['timestamp'].compareTo(b['timestamp']));

              if (lastVisible == null) {
                lastVisible = listMessage.last;
                listMessage.removeLast();
              }
            }

            return ListView.builder(
              ...
            );
          }
        },
      ),
    );
  }

After that to paginate I am using a listener with ScrollController

  void _scrollListener() async {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      _fetchMore();
    }
  }

and finally

  _fetchMore() {
    _firebase.firebaseDB
        .reference()
        .child("chats")
        .child("nsbcalculator")
        .orderByChild('timestamp')
        .startAt(lastVisible['timestamp'])
        .limitToFirst(5)
        .once()
        .then((snapshot) {

      List snapList = Map.from(snapshot.value).values.toList()
        ..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));


      if (snapList.isNotEmpty) {
        print(snapList.length.toString());

        if (!noMore) {

          listMessage.removeLast();

          //Problem is here.....??
          setState(() {
            listMessage..addAll(snapList);
          });

          lastVisible = snapList.last;

          print(lastVisible['content']);
        }

        if (snapList.length < 5) {
          noMore = true;
        }
      }
    });
  }

Its working fine as realtime communication but when I try to paginate in _fetchMore() setState is called but it refreshes the state of whole widget and restarts the StreamBuilder again and all data is replaced by only new query. How can I prevent this??

firebase
firebase-realtime-database
pagination
flutter
share  edit  follow 
asked Jan 31 '19 at 16:20

Shahzad Akram
1,47499 silver badges2929 bronze badges
Are you able to get it resolved? – Shajeel Afzal Jul 21 at 16:57
add a comment
2 Answers

3

Calling setState will redraw your whole widget and your list view. Now, since you supplying the steam that provides the first page, after redraw it just loads it. To avoid that you could use your own stream and supply new content to it. Then your StreamBuilder will handle the update automatically.

You need to store the full list of your items as a separate variable, update it and then sink to your stream.

final _list = List<Event>();
final _listController = StreamController<List<Event>>.broadcast();
Stream<List<Event>> get listStream => _listController.stream;

@override
void initState() {
  super.initState();
  // Here you need to load your first page and then add to your stream
  ...
  _list.addAll(firstPageItems);
  _listController.sink.add(_list);
}

@override
void dispose() {
  super.dispose();
}

Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: listStream
        ...
}

_fetchMore() {
  ...
  // Do your fetch and then just add items to the stream
  _list.addAll(snapList);
  _listController.sink.add(_list);
  ...
}
