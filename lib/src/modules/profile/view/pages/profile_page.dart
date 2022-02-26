import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/modules/chats/view/providers/providers.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final Logger logger = Logger("Profile");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: false,
        elevation: 1,
      ),
      body: ProviderStateBuilder<UserData>(
        watchThisProvider: userStreamProvider,
        logger: logger,
        builder: (user, ref) {
          return Padding(
            padding: const EdgeInsets.only(
              top: kPaddingMediumConstant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: kImageSizeLarge,
                    backgroundImage: CachedNetworkImageProvider(
                      user.photoURL ?? defaultPhotoURL,
                    ),
                  ),
                ),
                SizedBox(
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
                Spacer(),
                Divider(),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(chatsServiceStateNotifierProvider.notifier)
                        .disconnectUser();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
