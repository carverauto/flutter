import 'package:flutter/material.dart' show BuildContext, EdgeInsets, Flexible, ListView, NeverScrollableScrollPhysics, Padding, Row, SizedBox, StatelessWidget, Text, Widget;
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class URLView extends StatelessWidget {
  final List<Map> streams;

  const URLView(this.streams);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = List<Widget>.empty(growable: true);
    for (var item in streams) {
      children.add(
        Row(
          children: <Widget>[
            Flexible(
             child: Padding(
                padding: const EdgeInsets.all(0.4),
                // child: Linkify(onOpen: _onOpen, text: item.toString())),
                child: Linkify(onOpen: _onOpen, text: item["URL"]))
                // child: Text(item["URL"]))
            ),
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        const SizedBox(
          height: 10.0,
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(40.0, 25.0, 25.0, 5.0),
      // padding: EdgeInsets.all(0.2),
      children: children,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
