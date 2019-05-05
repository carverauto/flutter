import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class URLView extends StatelessWidget {
  final List<Map> urls;

  URLView(this.urls);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    urls.forEach((item) {
      children.add(
        new Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(0.3),
                // child: Linkify(onOpen: _onOpen, text: item.toString())),
                child: Linkify(onOpen: _onOpen, text: item["url"]))
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        new SizedBox(
          height: 10.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(40.0, 25.0, 25.0, 5.0),
      // padding: EdgeInsets.all(0.2),
      children: children,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
