import 'package:cast/device.dart';
import 'package:cast/discovery_service.dart';
import 'package:cast/session.dart';
import 'package:cast/session_manager.dart';
import 'package:flutter/material.dart';

import '../../../../const/sizings.dart';
import '../../../../shared/platform_views/airplay_view.dart';
import '../../../../shared/widgets/buttons/glass_button.dart';
import '../../../../shared/widgets/loaders/loading.dart';
import 'video_top_actions.dart';

class StreamingOptionsList extends StatelessWidget {
  const StreamingOptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBg(
      color: Colors.grey[100]!.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (Theme.of(context).platform == TargetPlatform.iOS ||
              Theme.of(context).platform == TargetPlatform.macOS)
            const SizedBox(
              height: 44,
              width: 44,
              child: AirplayView(),
            ),
          if (Theme.of(context).platform == TargetPlatform.iOS ||
              Theme.of(context).platform == TargetPlatform.macOS)
            const ChaseAppChromeCastButton(),
          IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierColor: Colors.transparent,
                builder: (BuildContext context) {
                  return const GoogleCastSolution();
                },
              );
            },
            icon: const Icon(
              Icons.cast,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleCastSolution extends StatefulWidget {
  const GoogleCastSolution({super.key});

  @override
  State<GoogleCastSolution> createState() => _GoogleCastSolutionState();
}

class _GoogleCastSolutionState extends State<GoogleCastSolution> {
  Future<void> _connect(BuildContext context, CastDevice object) async {
    final CastSession session = await CastSessionManager().startSession(object);

    session.stateStream.listen((CastSessionState state) {
      if (state == CastSessionState.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connected To ${object.name} for casting ')),
        );
        _sendMessage(session);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session Start Message Sent')),
        );
      }
    });

    session.messageStream.listen((Map<String, dynamic> message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message Recieved--> $message')),
      );
    });

    session.sendMessage(CastSession.kNamespaceReceiver, <String, dynamic>{
      'type': 'LAUNCH',
      'appId': 'ChaseApp', // set the appId of your app here
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Launching Message Sent')),
    );
  }

  void _sendMessage(CastSession session) {
    session.sendMessage('urn:x-cast:com.carverauto.chaseapp', <String, dynamic>{
      'type': 'sample',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingMediumConstant),
        child: Material(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
          elevation: 2,
          shadowColor: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(kPaddingMediumConstant),
            child: FutureBuilder<List<CastDevice>>(
              future: CastDiscoveryService().search(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<CastDevice>> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error.toString()}',
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.cast_outlined),
                          SizedBox(width: kPaddingSmallConstant),
                          Flexible(
                            child: Text(
                              'Looking for casting devices...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: kPaddingMediumConstant),
                      const CircularAdaptiveProgressIndicatorWithBg(),
                    ],
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cast_outlined),
                      SizedBox(width: kPaddingSmallConstant),
                      Flexible(
                        child: Text(
                          'No Chromecast Devices Founded',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: snapshot.data!.map((CastDevice device) {
                    return ListTile(
                      title: Text(
                        device.name,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        _connect(context, device);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
