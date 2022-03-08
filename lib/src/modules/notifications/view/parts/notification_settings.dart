import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/models/interest/interest.dart';
import 'package:chaseapp/src/modules/notifications/view/parts/notification_setting_tile.dart';
import 'package:chaseapp/src/modules/notifications/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationsSettings extends StatelessWidget {
  NotificationsSettings({Key? key}) : super(key: key);

  final Logger logger = Logger("NotificationsSettings");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Interests"),
        elevation: 0,
      ),
      body: ProviderStateBuilder<List<Interest>>(
        builder: (interests, ref, child) {
          return ProviderStateBuilder<List<String?>>(
              builder: (usersInterests, ref, child) {
                final defaultInterests =
                    interests.where((interest) => interest.isDefault).toList();
                final optionalInterests =
                    interests.where((interest) => !interest.isDefault).toList();

                return Padding(
                  padding:
                      const EdgeInsets.all(kPaddingMediumConstant).copyWith(
                    bottom: 0,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      InterestsHeader(name: "Default"),
                      InterestsList(
                        interests: defaultInterests,
                        usersInterests: usersInterests,
                      ),
                      InterestsHeader(name: "Optional"),
                      InterestsList(
                        interests: optionalInterests,
                        usersInterests: usersInterests,
                      ),
                    ],
                  ),
                );
              },
              watchThisProvider: usersInterestsStreamProvider,
              logger: logger);
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
          SizedBox(
            width: kItemsSpacingSmallConstant,
          ),
          Expanded(
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
    interests.sort(((a, b) => a.name.compareTo(b.name)));

    return interests.isEmpty
        ? SliverToBoxAdapter(
            child: Column(children: [
              // Icon(
              //   Icons.notifications_off_outlined,
              // ),
              Chip(
                label: Text(
                  "None Found",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              )
            ]),
          )
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final interest = interests[index];
                final isUsersInterest = usersInterests.contains(interest.name);
                return NotificationSettingTile(
                    interest: interest, isUsersInterest: isUsersInterest);
              },
              childCount: interests.length,
            ),
          );
  }
}
