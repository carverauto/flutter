import 'dart:developer';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/nodle_provider.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/app_update_info/app_update_info.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_wrapper.dart';
import 'package:chaseapp/src/modules/signin/view/pages/signin_page.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class AuthViewWrapper extends ConsumerWidget {
  final Logger logger = Logger("AuthViewWrapper");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppUpdateInfo>>(checkForUpdateStateNotifier,
        (previousState, newState) {
      newState.when(
        loading: () {},
        data: (appUpdateInfo) async {
          ref
              .watch(checkForUpdateStateNotifier.notifier)
              .showOrNotShowUpdateDialog(context);
        },
        error: (e, s) {
          log(e.toString());
        },
      );
    });

    return ProviderStateBuilder<User?>(
      watchThisProvider: streamLogInStatus,
      logger: logger,
      errorMessage: "Error while loading users login status.",
      builder: (user) {
        WidgetsBinding.instance!.addPostFrameCallback((t) {
          ref.read(checkForUpdateStateNotifier.notifier).checkForUpdate();
        });
        if (user == null) {
          return LogInView();
        }

        return ProviderStateBuilder<UserData>(
          watchThisProvider: fetchUserProvider(user),
          logger: logger,
          errorMessage: "Error while loading users data.",
          builder: (userData) {
            WidgetsBinding.instance!.addPostFrameCallback((t) {
              ref.read(nodleProvider.notifier).initializeNodle();
              ref
                  .read(chatsServiceStateNotifierProvider.notifier)
                  .connectUserToGetStream(userData);
              ref
                  .read(postLoginStateNotifierProvider.notifier)
                  .initPostLoginActions(user, userData);
            });

            return HomeWrapper();
          },
          errorBuilder: (e, stk) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChaseAppErrorWidget(
                    onRefresh: () {
                      ref.refresh(streamLogInStatus);
                    },
                  ),
                  SizedBox(
                    height: kItemsSpacingMedium,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authRepoProvider).signOut();
                    },
                    child: Text("Logout"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
