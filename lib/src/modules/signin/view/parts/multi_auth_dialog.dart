import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/util/helpers/multi_provider_helper.dart';
import 'package:flutter/material.dart';

class MultiAuthDialog extends StatelessWidget {
  const MultiAuthDialog({
    Key? key,
    required this.existingProviders,
  }) : super(key: key);

  final List<String> existingProviders;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(kPaddingMediumConstant),
      child: Padding(
        padding: EdgeInsets.all(kPaddingSmallConstant),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            Text(
              "Account exists with multiple sign in providers.",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Please sign in using any one of the previously used providers to continue.",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: kItemsSpacingSmall,
            ),
            Wrap(
              children: existingProviders.map<Widget>((provider) {
                final SIGNINMETHOD knownAuthProvider =
                    getSignInProviderHelper(provider);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, knownAuthProvider);
                    },
                    child: Text(knownAuthProvider.name),
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
