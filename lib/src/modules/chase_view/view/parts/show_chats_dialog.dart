import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:flutter/material.dart';

void showChatsDialog(BuildContext context, Chase chase) {
  showModalBottomSheet<void>(
    context: context,
    clipBehavior: Clip.hardEdge,
    enableDrag: false,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        kBorderRadiusStandard,
      ),
    ),
    builder: (context) {
      return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(kPaddingMediumConstant)
                  .copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chats",
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: Placeholder(),
                  ),
                ],
              ),
            );
          });
    },
  );
}
