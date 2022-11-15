import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../const/sizings.dart';
import '../../../routes/routeNames.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Column(
          children: [
            ListTile(
              tileColor: Theme.of(context).colorScheme.secondary,
              leading: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.bug_report,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kBorderRadiusStandard),
              ),
              iconColor: Colors.red,
              textColor: Colors.white,
              title: const Text('Report an issue'),
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.BUG_REPORT);
              },
            ),
            const Spacer(),
            Row(
              children: const [
                Text(
                  'Support Email: ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'chaseapp.tv@gmail.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
