import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/links.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/models/user/user_data.dart';
import 'package:chaseapp/src/shared/widgets/builders/providerStateBuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final Logger logger = Logger("Profile");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: kElevation,
        title: Image.asset(
          chaseAppNameImage,
          height: kImageSizeLarge,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ProviderStateBuilder<UserData>(
              watchThisProvider: userStreamProvider,
              logger: logger,
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
                              user.photoURL ?? defaultPhotoURL,
                            ),
                          ),
                        ),
                        Divider(
                          height: kItemsSpacingMedium,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Full Name :',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                            SizedBox(
                              width: kItemsSpacingSmallConstant,
                            ),
                            Text(
                              user.userName ?? "NA",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                          ],
                        ),
                        Divider(
                          height: kItemsSpacingMedium,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Email :',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                            SizedBox(
                              width: kItemsSpacingSmallConstant,
                            ),
                            Text(
                              user.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                            ),
                          ],
                        ),
                        Divider(
                          height: kItemsSpacingLarge,
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
