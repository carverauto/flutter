// import 'package:flutter/material.dart';

// import '../../../../const/colors.dart';
// import '../../../../const/info.dart';
// import '../../../../const/sizings.dart';
// import '../parts/grant_permissions_button.dart';
// import '../parts/permissions_list.dart';
// import '../../../dashboard/view/parts/chaseapp_appbar.dart';

// class RequestPermissionsView extends StatelessWidget {
//   const RequestPermissionsView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding:
//             const EdgeInsets.all(kPaddingMediumConstant).copyWith(bottom: 0),
//         child: ListView(
//           padding: const EdgeInsets.all(0),
//           children: [
//             const SizedBox(
//               height: kItemsSpacingSmallConstant,
//             ),
//             const ChaseAppLogoImage(),
//             const SizedBox(
//               height: kItemsSpacingMediumConstant,
//             ),
//             Container(
//               padding: const EdgeInsets.all(
//                 kPaddingSmallConstant,
//               ),
//               decoration: BoxDecoration(
//                 color: primaryColor.shade700,
//                 borderRadius: BorderRadius.circular(kBorderRadiusStandard),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     Icons.info,
//                     color: Theme.of(context).colorScheme.onPrimary,
//                   ),
//                   const SizedBox(
//                     width: kItemsSpacingSmallConstant,
//                   ),
//                   Expanded(
//                     child: Text(
//                       permissionsTitle,
//                       style: Theme.of(context).textTheme.subtitle2!.copyWith(
//                             fontWeight: FontWeight.normal,
//                             color: Theme.of(context).colorScheme.onPrimary,
//                           ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: kItemsSpacingMediumConstant,
//             ),
//             const PermissionsList(),
//             const SizedBox(
//               height: kItemsSpacingLargeConstant,
//             ),
//             const GrantAllPermissionsButton(),
//             const SizedBox(
//               height: kItemsSpacingMediumConstant,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
