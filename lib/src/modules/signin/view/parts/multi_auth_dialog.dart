import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../const/sizings.dart';
import '../../../../shared/enums/social_logins.dart';

class MultiAuthDialog extends StatelessWidget {
  const MultiAuthDialog({
    super.key,
    required this.existingProviders,
  });

  final List<String> existingProviders;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(kPaddingMediumConstant),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingSmallConstant),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            Text(
              'Account exists with multiple sign in providers.',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Please sign in using any one of the previously used providers to continue.',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: kItemsSpacingSmall,
            ),
            Wrap(
              children: existingProviders.map<Widget>((String provider) {
                final SIGNINMETHOD knownAuthProvider =
                    getSignInProviderHelper(provider);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, knownAuthProvider);
                    },
                    child: knownAuthProvider == SIGNINMETHOD.Unknown
                        ? Text(toBeginningOfSentenceCase(provider).toString())
                        : Text(knownAuthProvider.name),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class NotSupportedSignInProviderDialog extends StatelessWidget {
  const NotSupportedSignInProviderDialog({
    super.key,
    required this.authProviders,
  });

  final List<String> authProviders;

  @override
  Widget build(BuildContext context) {
    final List<SIGNINMETHOD> availableSigninAuthProviders =
        authProviders.map(getSignInProviderHelper).toList()
          ..removeWhere(
            (SIGNINMETHOD e) => e == SIGNINMETHOD.Unknown,
          );
    if (Platform.isAndroid &&
        availableSigninAuthProviders.contains(SIGNINMETHOD.Apple)) {
      availableSigninAuthProviders.remove(SIGNINMETHOD.Apple);
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(kPaddingMediumConstant),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingSmallConstant),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            Text(
              "Looks like we don't support the sign in method you're trying to sign in with.\nPlease try one of the other methods to continue.",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: kItemsSpacingSmall,
            ),
            Builder(
              builder: (BuildContext context) {
                // final List<SIGNINMETHOD> fallBackProvidersList =
                //     Platform.isAndroid
                //         ? [SIGNINMETHOD.Google]
                //         : [SIGNINMETHOD.Google, SIGNINMETHOD.Apple];

                return Wrap(
                  children: availableSigninAuthProviders
                      .map<Widget>((SIGNINMETHOD provider) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, provider);
                        },
                        child: Text(provider.name),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
