import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/const/widgets.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/launchLink.dart';
import 'package:chaseapp/src/shared/widgets/providerStateBuilder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: kElevation,
        title: Image.asset(chaseAppNameImage),
      ),
      body: ProviderStateBuilder<UserData>(
        watchThisProvider: userStreamProvider,
        builder: (user) {
          return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingMediumConstant,
                vertical: kPaddingMediumConstant,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: kImageSizeLarge,
                      backgroundImage: CachedNetworkImageProvider(
                          user.photoURL ?? defaultPhotoURL),
                    ),
                  ),
                  const Divider(height: kItemsSpacingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Full Name', style: TextStyle(fontSize: 17.0)),
                      Text(
                          ref
                                  .read(firebaseAuthProvider)
                                  .currentUser!
                                  .displayName ??
                              "NA",
                          style: const TextStyle(fontSize: 17.0)),
                    ],
                  ),
                  dividerMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Email', style: TextStyle(fontSize: 17.0)),
                      Text(
                          ref.read(firebaseAuthProvider).currentUser!.email ??
                              "NA",
                          style: const TextStyle(fontSize: 17.0)),
                    ],
                  ),
                  dividerLarge,
                  ElevatedButton(
                      onPressed: () async {
                        await launchUrl(privacyPolicy);
                      },
                      child: const Text('Privacy')),
                  ElevatedButton(
                      onPressed: () async {
                        await launchUrl(tosPolicy);
                      },
                      child: const Text('Terms of Service')),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Consumer(
                      builder: (context, ref, _) {
                        return ElevatedButton(
                          onPressed: () {
                            ref.read(authRepoProvider).signOut();
                          },
                          child: Text('Logout'),
                        );
                      },
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }
}
