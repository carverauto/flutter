// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// Future<void> showPermissionsInfoDialog(
//     BuildContext context, String permission, String permissionInfo) async {
//   if (Platform.isAndroid)
//     await showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: DialogTitle(
//               permission: permission,
//             ),
//             content: DialogContent(
//               permissionInfo: permissionInfo,
//             ),
//             actions: [
//               TextButton(
//                 style: TextButton.styleFrom(
//                   side: BorderSide(
//                     color: Theme.of(context).colorScheme.onBackground,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   "Close",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onBackground,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   else
//     showCupertinoDialog<void>(
//         context: context,
//         builder: (context) {
//           return CupertinoAlertDialog(
//             title: DialogTitle(
//               permission: permission,
//             ),
//             content: DialogContent(
//               permissionInfo: permissionInfo,
//             ),
//             actions: [
//               CupertinoDialogAction(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   "Close",
//                 ),
//               ),
//             ],
//           );
//         });
// }

// class DialogTitle extends StatelessWidget {
//   const DialogTitle({
//     Key? key,
//     required this.permission,
//   }) : super(key: key);

//   final String permission;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       permission,
//       style: TextStyle(
//         color: Theme.of(context).colorScheme.onBackground,
//       ),
//     );
//   }
// }

// class DialogContent extends StatelessWidget {
//   const DialogContent({
//     Key? key,
//     required this.permissionInfo,
//   }) : super(key: key);

//   final String permissionInfo;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           permissionInfo,
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//         ),
//       ],
//     );
//   }
// }
