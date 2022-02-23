// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class NotificationsView extends StatelessWidget {
//   const NotificationsView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Consumer(builder: (context, ref, child) {
//         final notificationsStreamState = ref.watch(notificationsStreamProvider);
//         return notificationsStreamState.when(
//           data: (data) => ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(data[index].title),
//                 subtitle: Text(data[index].body),
//               );
//             },
//           ),
//           loading: () => Center(child: CircularProgressIndicator()),
//           error: (error) => Center(child: Text(error.toString())),
//         );
//       }),
//     );
//   }
// }
