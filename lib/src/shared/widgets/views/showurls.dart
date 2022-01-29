import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class URLView extends StatelessWidget {
  final List<Map> streams;

  const URLView(this.streams);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: streams.length,
      itemBuilder: (context, index) {
        final data = streams[index];
        return Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            label: Linkify(
              onOpen: _onOpen,
              text: data["URL"],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
