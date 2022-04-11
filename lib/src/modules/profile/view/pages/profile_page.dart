import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:logging/logging.dart';

import '../../../../const/images.dart';
import '../../../../const/sizings.dart';
import '../../../../core/modules/auth/view/providers/providers.dart';
import '../../../../models/user/user_data.dart';
import '../../../../shared/widgets/builders/providerStateBuilder.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Logger logger = Logger('Profile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: false,
        elevation: 1,
      ),
      body: ProviderStateBuilder<UserData>(
        watchThisProvider: userStreamProvider,
        logger: logger,
        builder: (UserData user, WidgetRef ref, Widget? child) {
          return Padding(
            padding: const EdgeInsets.only(
              top: kPaddingMediumConstant,
            ),
            child: Column(
              children: <Widget>[
                Align(
                  child: CircleAvatar(
                    radius: kImageSizeLarge,
                    backgroundImage: CachedNetworkImageProvider(
                      user.photoURL ?? defaultPhotoURL,
                    ),
                  ),
                ),
                const SizedBox(
                  height: kItemsSpacingSmallConstant,
                ),
                if (user.userName != null)
                  Text(
                    user.userName!,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const Spacer(),
                const Divider(),
                TextButton(
                  onPressed: () async {
                    // await ref
                    //     .read(chatsServiceStateNotifierProvider.notifier)
                    //     .disconnectUser();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
