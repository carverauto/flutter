import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/util/helpers/deviceSize.dart';
import 'package:chaseapp/src/modules/signin/view/pages/signin_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  VideoState createState() => VideoState();

  void dispose() {}
}

// DeviceSize deviceSize;

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  void navigationPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<bool>(
        builder: (BuildContext context) => SignInPage()));
    // Navigator.pushNamed(context, 'LOGIN');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = DeviceSize(
        size: MediaQuery.of(context).size,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
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
                        height: 25.0,
                        fit: BoxFit.scaleDown,
                      ))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //TODO: Too big size
                  Lottie.asset('assets/41812-christmas-tree.json',
                      onLoaded: (composition) {
                    Timer(Duration(seconds: 3), () {
                      navigationPage();
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
