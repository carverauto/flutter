import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chaseapp/src/modules/signin/view/providers/sign_in_view_model.dart';
import 'package:chaseapp/src/shared/util/helpers/deviceSize.dart';
import 'package:chaseapp/src/modules/signin/view/pages/signin_page.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  VideoState createState() => VideoState();

  void dispose() {}
}

// DeviceSize deviceSize;

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  bool _showSignIn = true;

  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  void navigationPage() {
    Navigator.of(context).push(MaterialPageRoute<bool>(
        builder: (BuildContext context) =>
            SignInPage(toggleView: _toggleView)));
    // Navigator.pushNamed(context, 'LOGIN');
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    // animation.addListener(() => this.setState(() {}));
    animation.addListener(() {
      if (mounted) setState(() {});
    });

    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = DeviceSize(
        size: MediaQuery.of(context).size,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
    return ChangeNotifierProvider<SignInViewModel>(
        create: (_) => SignInViewModel(),
        child: Scaffold(
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
                  Lottie.asset('assets/41812-christmas-tree.json')
                ],
              ),
            ],
          ),
        ));
  }
}
