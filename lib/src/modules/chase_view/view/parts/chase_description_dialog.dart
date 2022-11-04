// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../const/sizings.dart';
import '../../../../models/chase/chase.dart';
import '../providers/providers.dart';

// ignore: long-method
void showDescriptionDialog(BuildContext context, String chaseId) {
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
    builder: (BuildContext context) {
      return BottomSheet(
        onClosing: () {},
        enableDrag: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(kPaddingMediumConstant)
                .copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, _) {
                          final String? description = ref.watch(
                            streamChaseProvider(chaseId).select(
                              (AsyncValue<Chase> value) => value.value?.desc,
                            ),
                          );

                          return Text(
                            description ?? 'NA',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: kItemsSpacingSmall,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
