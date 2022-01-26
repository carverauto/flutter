import 'dart:developer';

import 'package:chaseapp/src/modules/auth/view/pages/login_register.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_wrapper.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthViewWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Sizescaleconfig.setSizes(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).textScaleFactor,
    );
    final loggedinstatus = ref.watch(streamLogInStatus);

    return loggedinstatus.when(
      data: (user) {
        if (user != null) {
          return ref.watch(getUserProvider(user)).when(
                data: (userData) {
                  log("Logged in");
                  ref
                      .read(postLoginStateNotifierProvider.notifier)
                      .initPostLoginActions(user);

                  return HomeWrapper();
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
