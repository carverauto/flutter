import 'dart:developer';

import 'package:chaseapp/src/const/assets.dart';
import 'package:chaseapp/src/core/top_level_providers/services_providers.dart';
import 'package:chaseapp/src/modules/chase_view/view/pages/chaseDetails_page.dart';
import 'package:chaseapp/src/shared/util/helpers/date_added.dart';
import 'package:chaseapp/src/shared/widgets/appbar/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: <Widget>[TopBar()],
          )),
      body: ref.watch(streamChasesProvider).when(data: (chases) {
        log(chases.length.toString());
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: chases.map((chase) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                    title: Text(chase.name ?? "NA",
                        style: GoogleFonts.getFont('Poppins')),
                    // subtitle: Text(chase.Votes.toString() + ' donuts'),
                    subtitle: Text(dateAdded(chase)),
                    trailing: Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.black12,
                        child: SvgPicture.asset(donutSVG),
                      ),
                      label: Text(chase.votes.toString()),
                    ),
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowChase(
                                        record: chase,
                                        key: UniqueKey(),
                                      )))
                        }),
              ),
            );
          }).toList(),
        );
      }, error: (error, stackTrace) {
        return Center(
          child: Text('Error: $error'),
        );
      }, loading: () {
        return Center(
          child: CircularProgressIndicator(),
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