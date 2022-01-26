import 'package:cached_network_image/cached_network_image.dart';
import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/models/chase/chase.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/routes/routes.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/widgets/providerStateBuilder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: kElevation,
        title: Image.asset(chaseAppNameImage),
        actions: <Widget>[
          IconButton(
            icon: CircleAvatar(
              radius: kImageSizeMedium,
              backgroundImage: CachedNetworkImageProvider(
                  ref.read(firebaseAuthProvider).currentUser?.photoURL ??
                      'defaultPhotoURL'),
            ),
            onPressed: () => Navigator.pushNamed(
              // context, MaterialPageRoute(builder: (context) => Settings()))),
              context,
              RouteName.PROFILE,
            ),
          ),
        ],
      ),
      body: ProviderStateBuilder<List<Chase>>(
          watchThisProvider: streamChasesProvider,
          builder: (chases) {
            return ListView(
              padding: const EdgeInsets.symmetric(
                vertical: kPaddingMediumConstant,
                horizontal: kPaddingMediumConstant,
              ),
              children: chases.map((chase) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: kPaddingMediumConstant,
                  ),
                  child: ListTile(
                      style: ListTileStyle.list,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context).primaryColorLight,
                          width: kBorderSideWidthSmallConstant,
                        ),
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusSmallConstant),
                      ),
                      title: Text(chase.name ?? "NA",
                          style: GoogleFonts.getFont('Poppins')),
                      subtitle: Text(dateAdded(chase)),
                      trailing: Chip(
                        backgroundColor: Theme.of(context).hintColor,
                        avatar: SvgPicture.asset(donutSVG),
                        label: Text(
                          chase.votes.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.CHASE_VIEW,
                          arguments: {
                            "chase": chase,
                          },
                        );
                      }),
                );
              }).toList(),
            );
          }),
    );
  }
}


              /*
  if (chase?.ImageURL != null) {
    if (chase.ImageURL.isNotEmpty) {
      imageURL = chase.ImageURL.replaceAll(
          RegExp(r"\.([0-9a-z]+)(?:[?#]|$)",
            caseSensitive: false,
            multiLine: false,
          ), '_200x200.webp?');
    } else {
      imageURL = 'https://chaseapp.tv/icon.png';
    }
  } else {
    imageURL = 'https://chaseapp.tv/icon.png';
  }
   */