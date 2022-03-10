import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class TheaterRive extends StatefulWidget {
  const TheaterRive({
    Key? key,
  }) : super(key: key);

  @override
  State<TheaterRive> createState() => _TheaterRiveState();
}

class _TheaterRiveState extends State<TheaterRive> {
  late StateMachineController theaterController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // TODO: Listen to the state trigger stream from firebase doc or may be notifications through
    // pusher based on the state recieved ,trigger the state
    // final String state = data["state"];
    // playThiState( state);
  }

  void setStateMachine(Artboard artboard) {
    theaterController = StateMachineController.fromArtboard(artboard, 'Crowd')!;
    artboard.addController(theaterController);
  }

  void playThiState(String state) {
    final stateTrigger = theaterController.findInput<bool>(state) as SMITrigger;
    stateTrigger.fire();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.network(
      "https://github.com/chase-app/flutter-rive/blob/main/assets/animations/chase_app.riv?raw=true",
      stateMachines: const ['Theater'],
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
      onInit: (artboard) {
        setStateMachine(artboard);
      },
    );

    // Container(
    //   height: 300,
    //   color: Colors.red,
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: RiveAnimation.network(
    //           "https://github.com/chase-app/flutter-rive/blob/main/assets/animations/chase_app.riv?raw=true",
    //           stateMachines: const ['Theater'],
    //           animations: [],
    //           fit: BoxFit.cover,
    //           onInit: (artboard) {
    //             setStateMachine(artboard);
    //           },
    //         ),
    //       ),
    //       ButtonBar(
    //         children: ["Man Point Left", "Horse Fist", "Robot Hop"]
    //             .map<Widget>(
    //               (state) => ElevatedButton(
    //                 onPressed: () {
    //                   playThiState(state);
    //                 },
    //                 child: Text(state),
    //               ),
    //             )
    //             .toList(),
    //       )
    //     ],
    //   ),
    // );
  }
}
