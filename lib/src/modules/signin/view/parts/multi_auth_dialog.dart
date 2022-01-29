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
            Text(
              "Account already created with different Provider. Please sign in with the provider you used to create the account at first. This will link your account with the provider you are currently using.",
              style: Theme.of(context).textTheme.subtitle1,
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
