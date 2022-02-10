import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';

class URLView extends StatelessWidget {
  final List<Map> streams;

  const URLView(this.streams);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: streams
          .map<Widget>((data) => Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  label: Linkable(
                    text: data["URL"] as String,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
