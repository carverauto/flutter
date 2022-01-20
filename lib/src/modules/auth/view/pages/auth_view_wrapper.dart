import 'dart:developer';

import 'package:chaseapp/src/modules/auth/view/pages/login_register.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/shared/util/helpers/request_permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedinstatus = ref.watch(streamLogInStatus);

    return loggedinstatus.when(
      data: (user) {
        if (user != null) {
          return ref.watch(createUserProvider).when(
                data: (v) {
                  requestPermissions();

                  ref.read(authRepoProvider).saveFirebaseDeviceToken();
                  ref.read(authRepoProvider).subscribeToTopics();
                  return HomePage();
                },
                error: (e, s) {
                  log("ERROR --->", error: e);
                  return Text(e.toString());
                },
                loading: () => Center(child: CircularProgressIndicator()),
              );
        }

        return const LoginOrRegister();
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, s) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text(e.toString())],
          ),
        ),
      ),
    );
  }
}
