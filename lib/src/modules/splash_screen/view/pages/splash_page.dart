import 'dart:async';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/core/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/routes/routeNames.dart';
import 'package:chaseapp/src/shared/util/helpers/sizescaleconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  VideoState createState() => VideoState();

  void dispose() {}
}

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precachePicture(
        SvgPicture.asset("assets/icon/google.svg").pictureProvider, context);
    precachePicture(
        SvgPicture.asset("assets/icon/apple.svg").pictureProvider, context);
    precachePicture(
        SvgPicture.asset("assets/icon/facebook.svg").pictureProvider, context);
    precachePicture(
        SvgPicture.asset("assets/icon/twitter.svg").pictureProvider, context);
    Sizescaleconfig.setSizes(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).textScaleFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(signInProvider);
        return Scaffold(
          backgroundColor: Colors.blueGrey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Image.asset(
                      'assets/powered_by.png',
                      height: kImageSizeSmall,
                      fit: BoxFit.scaleDown,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //TODO: Too big asset size
                  Lottie.asset('assets/47816-lunar-new-year-lion-dance.json',
                      onLoaded: (composition) {
                    Timer(Duration(seconds: 3), () async {
                      final user = await ref.read(streamLogInStatus.future);
                      Navigator.of(context).pushReplacementNamed(
                        user != null
                            ? RouteName.CHECK_PERMISSIONS_VIEW_WRAPPER
                            : RouteName.ONBOARDING_VIEW,
                      );
                    });
                  })
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
