// ignore_for_file: cascade_invocations

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../const/sizings.dart';
import '../../../../../models/app_update_info/app_update_info.dart';
import '../../../../../models/user/user_data.dart';
import '../../../../../modules/home/view/pages/home_wrapper.dart';
import '../../../../../modules/signin/view/pages/signin_page.dart';
import '../../../../../shared/widgets/builders/providerStateBuilder.dart';
import '../../../../../shared/widgets/errors/error_widget.dart';
import '../../../../top_level_providers/services_providers.dart';
import '../providers/providers.dart';

class AuthViewWrapper extends ConsumerWidget {
  AuthViewWrapper({super.key});

  final Logger logger = Logger('AuthViewWrapper');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppUpdateInfo>>(
      checkForUpdateStateNotifier,
      (
        AsyncValue<AppUpdateInfo>? previousState,
        AsyncValue<AppUpdateInfo> newState,
      ) {
        newState.when(
          loading: () {},
          data: (AppUpdateInfo appUpdateInfo) async {
            await ref
                .watch(checkForUpdateStateNotifier.notifier)
                .showOrNotShowUpdateDialog(context);
          },
          error: (Object e, StackTrace? s) {
            log(e.toString());
          },
        );
      },
    );

    return ProviderStateBuilder<User?>(
      watchThisProvider: streamLogInStatus,
      logger: logger,
      errorMessage: 'Error while loading users login status.',
      builder: (User? user, WidgetRef ref, Widget? child) {
        WidgetsBinding.instance.addPostFrameCallback((Duration t) {
          ref.read(checkForUpdateStateNotifier.notifier).checkForUpdate();
        });
        if (user == null) {
          return const LogInView();
        }

        final AutoDisposeFutureProvider<UserData> userFutureProvider =
            fetchUserProvider(user);

        return ProviderStateBuilder<UserData>(
          watchThisProvider: userFutureProvider,
          logger: logger,
          errorMessage: 'Error while loading users data.',
          builder: (UserData userData, WidgetRef ref, Widget? child) {
            return const HomeWrapper();
          },
          errorBuilder: (Object e, StackTrace? stk) {
            const String message =
                'Something went wrong. Please try again or contact us.';

            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChaseAppErrorWidget(
                    message: message,
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
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
