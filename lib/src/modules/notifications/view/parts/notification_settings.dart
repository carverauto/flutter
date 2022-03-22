import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../../const/sizings.dart';
import '../../../../models/interest/interest.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../providers/providers.dart';
import 'notification_setting_tile.dart';

class NotificationsSettings extends StatelessWidget {
  NotificationsSettings({Key? key}) : super(key: key);

  final Logger logger = Logger('NotificationsSettings');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications Interests'),
        elevation: 0,
      ),
      body: ProviderStateBuilder<List<Interest>>(
        builder: (List<Interest> interests, WidgetRef ref, Widget? child) {
          return ProviderStateBuilder<List<String?>>(
            builder:
                (List<String?> usersInterests, WidgetRef ref, Widget? child) {
              final List<Interest> defaultInterests = interests
                  .where((Interest interest) => interest.isDefault)
                  .toList();
              final List<Interest> optionalInterests = interests
                  .where((Interest interest) => !interest.isDefault)
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(kPaddingMediumConstant).copyWith(
                  bottom: 0,
                ),
                child: CustomScrollView(
                  slivers: [
                    const InterestsHeader(name: 'Default'),
                    InterestsList(
                      interests: defaultInterests,
                      usersInterests: usersInterests,
                    ),
                    const InterestsHeader(name: 'Optional'),
                    InterestsList(
                      interests: optionalInterests,
                      usersInterests: usersInterests,
                    ),
                  ],
                ),
              );
            },
            watchThisProvider: usersInterestsStreamProvider,
            logger: logger,
          );
        },
        watchThisProvider: interestsProvider,
        logger: logger,
      ),
    );
  }
}

class InterestsHeader extends StatelessWidget {
  const InterestsHeader({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.subtitle1?.fontSize,
            ),
          ),
          const SizedBox(
            width: kItemsSpacingSmallConstant,
          ),
          const Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }
}

class InterestsList extends StatelessWidget {
  const InterestsList({
    Key? key,
    required this.interests,
    required this.usersInterests,
  }) : super(key: key);

  final List<Interest> interests;
  final List<String?> usersInterests;

  @override
  Widget build(BuildContext context) {
    interests.sort((Interest a, Interest b) => a.name.compareTo(b.name));

    return interests.isEmpty
        ? SliverToBoxAdapter(
            child: Column(
              children: [
                // Icon(
                //   Icons.notifications_off_outlined,
                // ),
                Chip(
                  label: Text(
                    'None Found',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ],
            ),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final Interest interest = interests[index];
                final bool isUsersInterest =
                    usersInterests.contains(interest.name);
                return NotificationSettingTile(
                  interest: interest,
                  isUsersInterest: isUsersInterest,
                );
              },
              childCount: interests.length,
            ),
          );
  }
}
