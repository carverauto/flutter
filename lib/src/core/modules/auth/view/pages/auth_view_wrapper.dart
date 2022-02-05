import 'dart:developer';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/pages/login_register.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/core/top_level_providers/nodle_provider.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/app_update_info/app_update_info.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_wrapper.dart';
import 'package:chaseapp/src/shared/widgets/errors/error_widget.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class AuthViewWrapper extends ConsumerWidget {
  final Logger logger = Logger("AuthViewWrapper");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedinstatus = ref.watch(streamLogInStatus);

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

    return loggedinstatus.when(
        data: (user) {
          if (user != null) {
            return ref.watch(fetchUserProvider(user)).when(
                  data: (userData) {
                    WidgetsBinding.instance!.addPostFrameCallback((t) {
                      ref.read(nodleProvider.notifier).initializeNodle();

                      ref
                          .read(postLoginStateNotifierProvider.notifier)
                          .initPostLoginActions(user, userData);
                      ref
                          .read(checkForUpdateStateNotifier.notifier)
                          .doRequest();
                    });

                    return HomeWrapper();
                  },
                  error: (e, stk) {
                    logger.severe("Error while loading users data.", e, stk);

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
                  loading: () => Scaffold(
                    body: CircularAdaptiveProgressIndicatorWithBg(),
                  ),
                );
          }

          WidgetsBinding.instance!.addPostFrameCallback((t) {
            ref.read(checkForUpdateStateNotifier.notifier).doRequest();
          });

          return const LoginOrRegister();
        },
        loading: () => Scaffold(
              body: CircularAdaptiveProgressIndicatorWithBg(),
            ),
        error: (e, stk) {
          logger.severe("Error while loading users login status.", e, stk);
          return Scaffold(
            body: ChaseAppErrorWidget(
              message: "Something went wrong. Please try again later.",
              onRefresh: () {
                ref.refresh(streamLogInStatus);
              },
            ),
          );
        });
  }
}
