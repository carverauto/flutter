import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../const/sizings.dart';
import '../../../core/modules/auth/view/providers/providers.dart';
import '../../../core/top_level_providers/services_providers.dart';
import '../../../routes/routeNames.dart';
import '../../../shared/util/firebase_collections.dart';
import '../../../shared/widgets/loaders/loading.dart';

Future<ui.Image> takeAppScreenshot(Reader read) async {
  final RenderRepaintBoundary boundary = read(appGlobalKeyProvider)
      .currentContext!
      .findRenderObject() as RenderRepaintBoundary;

  final ui.Image image = await boundary.toImage(pixelRatio: 3);

  return image;
}

final StateProvider<ui.Image?> capturedSupportAppImageProvider =
    StateProvider<ui.Image?>((StateProviderRef<ui.Image?> ref) {
  return null;
});
final StateProvider<bool> isCapturingScreenshotFromAppProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return false;
});

final StateProvider<String?> currentRouteProvider = StateProvider<String?>(
  (StateProviderRef<String?> ref) {
    return null;
  },
);

// add feedbackFormTexteditcontrollerprpvider and emailcontrollerprovider

final StateProvider<String?> bugReportDescProvider = StateProvider<String?>(
  (StateProviderRef<String?> ref) {
    return null;
  },
);

class FeedbackForm extends ConsumerStatefulWidget {
  const FeedbackForm({
    super.key,
  });

  @override
  ConsumerState<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<FeedbackForm> {
  final Logger logger = Logger('FeedbackForm');

  bool isReportSubmitted = false;
  bool isSubmittingReport = false;
  late final TextEditingController emailController;
  late final TextEditingController bugReportController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      ref.read(currentRouteProvider.state).state = RouteName.BUG_REPORT;
    });
    final User? user = FirebaseAuth.instance.currentUser;
    final String? contactEmail =
        user != null ? ref.read(userStreamProvider).value?.contactEmail : null;
    emailController = TextEditingController(
      text: contactEmail,
    );
    final String? description = ref.read(bugReportDescProvider)?.isEmpty ?? true
        ? null
        : ref.read(bugReportDescProvider);
    bugReportController = TextEditingController(
      text: description,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    bugReportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ui.Image? image = ref.watch(capturedSupportAppImageProvider);
    final bool isCapuringImageFromApp =
        ref.watch(isCapturingScreenshotFromAppProvider);

    return WillPopScope(
      onWillPop: () async {
        ref.read(bugReportDescProvider.state).state = bugReportController.text;
        ref.read(currentRouteProvider.state).state = null;

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bug Report'),
          centerTitle: false,
        ),
        resizeToAvoidBottomInset: true,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: isReportSubmitted
              ? Padding(
                  padding: const EdgeInsets.all(kPaddingMediumConstant),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(kPaddingSmallConstant),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check),
                      ),
                      const SizedBox(height: kPaddingMediumConstant),
                      const Text(
                        'Thank you for reporting the issue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: kPaddingMediumConstant),
                      const Text(
                        'We might contact you at the contact email you provided if we need any assistance from you to resolve this quickly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: kPaddingMediumConstant),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            ref
                                .read(capturedSupportAppImageProvider.state)
                                .state = null;
                            isReportSubmitted = false;
                            bugReportController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.bug_report,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'File another issue',
                        ),
                      ),
                    ],
                  ),
                )
              : isSubmittingReport
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Submitting report.\nPlease don't close the app.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: kPaddingSmallConstant,
                          ),
                          CircularAdaptiveProgressIndicatorWithBg(),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        if (image == null && !isCapuringImageFromApp)
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                padding: const EdgeInsets.all(12),
                              ),
                              onPressed: () async {
                                final bool? captureFromApp =
                                    await showCupertinoDialog<bool?>(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: DecoratedBox(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              kBorderRadiusStandard,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              icon:
                                                  const Icon(Icons.camera_alt),
                                              label: const Text(
                                                'Take Screenshot From App',
                                              ),
                                            ),
                                            // OutlinedButton.icon(
                                            //   onPressed: () {
                                            //     Navigator.of(context).pop(false);
                                            //   },
                                            //   icon: const Icon(
                                            //     Icons.photo_album,
                                            //   ),
                                            //   label: const Text(
                                            //     'Pick From Photos',
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (captureFromApp != null) {
                                  if (captureFromApp) {
                                    Navigator.of(context)
                                        .focusScopeNode
                                        .unfocus();
                                    ref
                                        .read(
                                          isCapturingScreenshotFromAppProvider
                                              .state,
                                        )
                                        .update((bool state) => true);
                                  } else {
                                    // TODO: Pick from photos
                                  }
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Attach Image (optional)'),
                            ),
                          ),
                        if (image != null && !isCapuringImageFromApp)
                          Padding(
                            padding:
                                const EdgeInsets.all(kPaddingSmallConstant),
                            child: Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            kBorderRadiusStandard,
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: 2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            kPaddingXSmallConstant,
                                          ),
                                          child: RawImage(
                                            image: image,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -20,
                                    right: -20,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                              capturedSupportAppImageProvider
                                                  .state,
                                            )
                                            .update((ui.Image? state) => null);
                                      },
                                      child: const Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (image == null && isCapuringImageFromApp)
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    backgroundColor: Colors.white,
                                    fixedSize: const Size.fromHeight(
                                      64,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.camera,
                                    color: Colors.blue,
                                    size: kIconSizeLargeConstant,
                                  ),
                                ),
                                const SizedBox(
                                  height: kPaddingSmallConstant,
                                ),
                                Text(
                                  'Browse the app and take screenshot of issue by tapping the button shown at bottom right corner of screen.',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: kFontSizeSmallConstant,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: kPaddingLargeConstant,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingMediumConstant,
                              ),
                              child: GetUserContactEmail(
                                emailController: emailController,
                              ),
                            ),
                            const SizedBox(
                              height: kPaddingSmallConstant,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: kPaddingMediumConstant,
                                    ),
                                    child: Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '*',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        TextField(
                                          controller: bugReportController,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                          maxLines: 3,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText: 'Write your query here',
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                            ),

                                            // add borders
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondaryContainer,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  child: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom ==
                                          0
                                      ? const SizedBox(
                                          width: kPaddingMediumConstant,
                                        )
                                      : SizedBox(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              shape: const CircleBorder(),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .focusScopeNode
                                                  .unfocus();
                                            },
                                            child: const Icon(
                                              Icons.arrow_downward_rounded,
                                            ),
                                          ),
                                        ),
                                  transitionBuilder: (
                                    Widget child,
                                    Animation<double> animation,
                                  ) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: kPaddingMediumConstant,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (bugReportController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter your query',
                                    ),
                                  ),
                                );
                                return;
                              }
                              Navigator.of(context).focusScopeNode.unfocus();
                              setState(() {
                                isSubmittingReport = true;
                              });
                              final String? userId =
                                  FirebaseAuth.instance.currentUser?.uid;
                              try {
                                String? imageUrl;
                                if (emailController.value.text.isNotEmpty) {
                                  if (userId != null) {
                                    await usersCollectionRef
                                        .doc(userId)
                                        .update({
                                      'contactEmail':
                                          emailController.value.text,
                                    });
                                  }
                                }
                                if (image != null) {
                                  // store the image to firebase storage at child bug_reports/userid
                                  final String folder = userId ?? 'unknown';
                                  final Reference firebaseStorage =
                                      FirebaseStorage.instance
                                          .ref()
                                          .child(
                                            'bug_reports/$folder',
                                          )
                                          .child(
                                            DateTime.now().toString(),
                                          );
                                  log(firebaseStorage.fullPath);
                                  final ByteData? imagebytes =
                                      await image.toByteData(
                                    format: ui.ImageByteFormat.png,
                                  );

                                  final TaskSnapshot uploadTask =
                                      await firebaseStorage.putData(
                                    imagebytes!.buffer.asUint8List(),
                                    SettableMetadata(
                                      contentType: 'image/png',
                                    ),
                                  );
                                  imageUrl =
                                      await uploadTask.ref.getDownloadURL();
                                }

                                final CollectionReference<Map<String, dynamic>>
                                    firestore = FirebaseFirestore.instance
                                        .collection('bug_reports');
                                final String version =
                                    ref.read(appInfoProvider).version;

                                await firestore.doc().set(<String, dynamic>{
                                  'desc': bugReportController.text,
                                  'imageUrl': imageUrl,
                                  'timestamp': DateTime.now(),
                                  'uid': userId,
                                  'contactEmail': emailController.value.text,
                                  'platform': Theme.of(context).platform.name,
                                  'appVersion': version,
                                });
                                await Future<void>.delayed(
                                  const Duration(
                                    seconds: 1,
                                  ),
                                );
                                setState(() {
                                  isReportSubmitted = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Report submitted successfully',
                                    ),
                                  ),
                                );
                              } catch (e, stk) {
                                logger.warning(
                                  'Error while submitting bug report',
                                  e,
                                  stk,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Something went wrong. Please try again later.',
                                    ),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  isSubmittingReport = false;
                                });
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                        const SizedBox(
                          height: kPaddingMediumConstant,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class GetUserContactEmail extends StatefulWidget {
  const GetUserContactEmail({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  State<GetUserContactEmail> createState() => _GetUserContactEmailState();
}

class _GetUserContactEmailState extends State<GetUserContactEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: widget.emailController,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            labelText: 'Contact Email',
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary),
            hintText: 'Enter your contact email',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            // add borders
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: kPaddingMediumConstant,
        ),
      ],
    );
  }
}
