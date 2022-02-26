import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/modules/chats/view/parts/chats_view.dart';
import 'package:flutter/material.dart';

void showChatsViewBottomSheet(BuildContext context, Chase chase) {
  showModalBottomSheet<void>(
    context: context,
    // enableDrag: false,
    elevation: 1,
    isScrollControlled: true,

    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        kBorderRadiusStandard,
      ),
    ),
    builder: (context) {
      return ChatsView(
        chase: chase,
      );
    },
  );
}
