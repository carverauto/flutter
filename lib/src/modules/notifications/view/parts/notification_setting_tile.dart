// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/notifiers/in_app_purchases_state_notifier.dart';
import '../../../../core/top_level_providers/services_providers.dart';
import '../../../../models/interest/interest.dart';
import '../../../in_app_purchases/views/view_helpers.dart';
import '../providers/providers.dart';

class NotificationSettingTile extends StatelessWidget {
  const NotificationSettingTile({
    super.key,
    required this.interest,
    required this.isUsersInterest,
  });

  final Interest interest;
  final bool isUsersInterest;

  @override
  Widget build(BuildContext context) {
    final String displayName =
        toBeginningOfSentenceCase(interest.name.split('-')[0])!;

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        displayName,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: NotificationSettingTileSwitch(
        interest: interest,
        isUsersInterest: isUsersInterest,
        displayName: displayName,
      ),
    );
  }
}

class NotificationSettingTileSwitch extends ConsumerStatefulWidget {
  const NotificationSettingTileSwitch({
    super.key,
    required this.interest,
    required this.isUsersInterest,
    required this.displayName,
  });

  final Interest interest;
  final bool isUsersInterest;
  final String displayName;

  @override
  ConsumerState<NotificationSettingTileSwitch> createState() =>
      _NotificationSettingTileSwitchState();
}

class _NotificationSettingTileSwitchState
    extends ConsumerState<NotificationSettingTileSwitch> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.isUsersInterest;
  }

  // ignore: long-method
  Future<void> toggleSubscription(BuildContext context, bool value) async {
    final bool isPremiumMember =
        ref.read(inAppPurchasesStateNotifier).value?.isPremiumMember ?? false;

    if (widget.interest.isPremium && !isPremiumMember) {
      await showInAppPurchasesBottomSheet(context);

      return;
    }

    try {
      if (value) {
        await ref
            .read(pusherBeamsProvider)
            .addDeviceInterest(widget.interest.name);
        if (mounted) {
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text(
                'Subscribed to ${widget.displayName} notifications.',
              ),
            ),
          );
        }
      } else {
        await ref
            .read(pusherBeamsProvider)
            .removeDeviceInterest(widget.interest.name);
        if (mounted) {
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Text(
                'UnSubscribed from ${widget.displayName} notifications.',
              ),
            ),
          );
        }
      }

      setState(() {
        isEnabled = value;
        ref.refresh(usersInterestsStreamProvider);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something went wrong. Please try again later.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isEnabled,
      onChanged: (bool value) {
        toggleSubscription(context, value);
      },
    );
  }
}
