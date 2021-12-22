import 'package:chaseapp/base/base_view.dart';
import 'package:chaseapp/helper/progressBar.dart';
import 'package:chaseapp/helper/routeNames.dart';
import 'package:chaseapp/helper/deviceSize.dart';
import 'package:chaseapp/helper/helper_functions.dart';
import 'package:chaseapp/shared/view_state.dart';
import 'package:chaseapp/viewModels/sign_in_view_model.dart';
import 'package:chaseapp/services/auth_service.dart';
import 'package:chaseapp/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({required this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isSignedIn = false;
  bool google = false;

  // text field state
  String email = '';
  late String name;
  late String imageUrl;
  String password = '';
  String error = '';

  Future<void> requestPermissions() async {
    print("in requestPermissions");
    final btScanStatus = await Permission.bluetoothScan;
    final btConnectStatus = await Permission.bluetoothConnect;
    final btServiceStatus = await Permission.bluetooth;
    final locationAlwaysStatus = await Permission.locationAlways;
    final locationStatus = await Permission.location;
    final notifyStatus = await Permission.notification;

    bool isBtOn = btServiceStatus == btServiceStatus.isGranted;
    bool isBtScanOn = btScanStatus == btScanStatus.isGranted;
    bool isBtConnectOn = btConnectStatus == btConnectStatus.isGranted;
    bool isLocationOn = locationStatus == locationStatus.isGranted;
    bool isLocationAlwaysOn = locationAlwaysStatus == locationAlwaysStatus.isGranted;
    bool isNotifyOn = notifyStatus == notifyStatus.isGranted;

    final permBtServiceStatus = await Permission.bluetooth.request();
    final permBtScanStatus = await Permission.bluetoothScan.request();
    final permBtConnectStatus = await Permission.bluetoothConnect.request();
    final permLocationStatus = await Permission.location.request();
    final permLocationAlwaysStatus = await Permission.locationAlways.request();
    final permNotifyStatus = await Permission.notification.request();

    if (permBtServiceStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('BTServiceStatus - Permission Granted');
      }
    } else if (permBtServiceStatus == PermissionStatus.denied) {
      if (kDebugMode) {
        print('BTServiceStatus - Permission Denied');
      }
    } else if (permBtServiceStatus == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('BTServiceStatus - Permission Permanently Denied');
      }
      await openAppSettings();
    }

    if (permBtScanStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('BTScanStatus - Permission Granted');
      }
    } else if (permBtScanStatus == PermissionStatus.denied) {
      if (kDebugMode) {
        print('BTScanStatus - Permission Denied');
      }
    } else if (permBtScanStatus == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('BTScanStatus - Permission Permanently Denied');
      }
      await openAppSettings();
    }

    if (permBtConnectStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('BTConnectStatus - Permission Granted');
      }
    } else if (permBtConnectStatus == PermissionStatus.denied) {
      if (kDebugMode) {
        print('BTConnectStatus - Permission Denied');
      }
    } else if (permBtConnectStatus == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('BTConnectStatus - Permission Permanently Denied');
      }
      await openAppSettings();
    }

    if (permLocationAlwaysStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('LocationAlways - Permission Granted');
      }
    } else if (permLocationAlwaysStatus == PermissionStatus.denied) {
      if (kDebugMode) {
        print('LocationAlways - Permission Denied');
      }
    } else if (permLocationAlwaysStatus == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('LocationAlways - Permission Permanently Denied');
      }
      await openAppSettings();
    }

    if (permLocationStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('Location - Permission Granted');
      }
    } else if (permLocationStatus == PermissionStatus.denied) {
      if (kDebugMode) {
        print('Location - Permission Denied');
      }
    } else if (permLocationStatus == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('Location - Permission Permanently Denied');
      }
      await openAppSettings();
    }

    if (permNotifyStatus == PermissionStatus.granted) {
      if (kDebugMode) {
        print('Notifications - Permission Granted');
      }
    } else if (permNotifyStatus == PermissionStatus.denied) {
      if (kDebugMode) {
        print('Notifications - Permission Denied');
      }
    } else if (permNotifyStatus == PermissionStatus.permanentlyDenied) {
      if (kDebugMode) {
        print('Notifications - Permission Permanently Denied');
      }
      await openAppSettings();
    }

    startNodle();
  }

  // Nodle
  static const platform = MethodChannel('com.carverauto.chaseapp/nodle');

  // Define an async function to start Nodle SDK
  void startNodle() async {
    try {
      String value = await platform.invokeMethod("start");
      if (kDebugMode) {
        print(value);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _onSignInWithGoogle(SignInViewModel model) async {
    await requestPermissions();
    User? user;

    bool isSignedIn = await _googleSignIn.isSignedIn();

    //setState(() {
    //  isUserSignedIn = userSignedIn;
    //});

    // Check to see if we're signed in already
    if (isSignedIn) {
      model.state = ViewState.Busy;
      user = FirebaseAuth.instance.currentUser;

      // go to the home page
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          RouteName.Home,
              (Route<dynamic> route) =>
          false);
    } else {
      await _auth.signInWithGoogle().then((result) async {
        model.state = ViewState.Busy;
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService(uid: user!.uid).getUserData(
              result.email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          // https://stackoverflow.com/questions/67447001/firebase-firestore-error-the-operator-isnt-defined-for-the-class-object
          await HelperFunctions.saveUserNameSharedPreference( // #TODO: debug this, see if it is working
              (userInfoSnapshot.docs[0].data() as Map<String,dynamic>)['fullName']
          );

          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            if (kDebugMode) {
              print("Logged in: $value");
            }
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            if (kDebugMode) {
              print("Email: $value");
            }
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            if (kDebugMode) {
              print("Full Name: $value");
            }
          });

          // Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => HomePage()));

          Navigator.of(context)
              .pushNamedAndRemoveUntil(
              RouteName.Home,
                  (Route<dynamic> route) =>
              false);
        }
        else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  _onSignIn(SignInViewModel model) async {
    if (kDebugMode) {
      print("_onSignIn");
    }
    User? user;
    user = FirebaseAuth.instance.currentUser;
    await requestPermissions();
    model.state = ViewState.Busy;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

        await _auth.signInWithEmailAndPassword(email, password).then((
            result) async {
          if (result != null) {
            QuerySnapshot userInfoSnapshot = await DatabaseService(uid: user!.uid).getUserData(
                email);

            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(
                (userInfoSnapshot.docs[0].data() as Map<String,dynamic>)['fullName']
            );

            print("Signed In");
            await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
              print("Logged in: $value");
            });
            await HelperFunctions.getUserEmailSharedPreference().then((value) {
              print("Email: $value");
            });
            await HelperFunctions.getUserNameSharedPreference().then((value) {
              print("Full Name: $value");
            });

            // Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => HomePage()));

            Navigator.of(context)
                .pushNamedAndRemoveUntil(
                RouteName.Home,
                    (Route<dynamic> route) =>
                false);
          }
          else {
            setState(() {
              error = 'Error signing in!';
              _isLoading = false;
            });
          }
        });
    } // email

  }


  @override
  Widget build(BuildContext context) {
    return BaseView<SignInViewModel>(
        onModelReady: (model) {},
        builder: (context, model, build) {
          return WillPopScope(
            child: SafeArea(
              child: Scaffold(
                // backgroundColor: Color(0xFFE6E6E6),
                // backgroundColor: Vx.gray200,
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: 410,
                      width: 430,
                      // decoration: BoxDecoration( image: DecorationImage( image: AssetImage('assets/background.png'), fit: BoxFit.contain, ), ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize!.height / 5.4,
                            // width: deviceSize.width / 1,
                            decoration: const BoxDecoration(
                              //border: Border.all( color: Colors.black, width: 8),
                              image: DecorationImage(
                                image:
                                AssetImage('assets/chaseapp.png'),
                              ),
                            ),
                          ),
                          Container(
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 15, left: 10, right: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20.0)),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        // Old way
                                        child: Text( "Login", style: TextStyle( fontWeight: FontWeight.w800, fontSize: 25),),
                                        // new VX way
                                        // child: "Login" .text .blue400 .bold .size(25) .makeCentered(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0,
                                            right: 14,
                                            left: 14,
                                            bottom: 8),
                                        child: TextFormField(
                                          controller: model.userIdController,
                                          validator: (val) {
                                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ? null : "Please enter a valid email";
                                          },
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                            });
                                          },
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            hintText: "Email",
                                            hintStyle: TextStyle(fontSize: 15),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                          ),
                                          cursorColor: Colors.black,
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          /*
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter
                                                .singleLineFormatter,
                                          ],
                                           */
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0,
                                            right: 14,
                                            left: 14,
                                            bottom: 8),
                                        child: TextFormField(
                                          controller: model.passwordController,
                                          validator: (val) => val!.length < 6 ? 'Password not strong enough': null,
                                          obscureText: !model.passwordVisible,
                                          onChanged: (val) {
                                            setState(() {
                                              password = val;
                                            });
                                          },
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            hintText: "Password",
                                            contentPadding: const EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            hintStyle: TextStyle(fontSize: 15),
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  model.passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Color(0xFFE6E6E6),
                                                ),
                                                onPressed: () {
                                                  model.passwordVisible =
                                                  !model.passwordVisible;
                                                  _onSignIn(model);
                                                }),
                                          ),
                                          cursorColor: Colors.black,
                                          /*
                                          inputFormatters: <TextInputFormatter>[
                                            BlacklistingTextInputFormatter.singleLineFormatter,
                                          ],
                                           */
                                        ),
                                      ),

                                      SizedBox( height: 10.0),

                                      Text.rich(
                                        TextSpan(
                                          text: "Don't have an account? ",
                                          style: TextStyle(fontSize: 14.0),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Register here',
                                              style: const TextStyle(
                                                  decoration: TextDecoration.underline
                                              ),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                widget.toggleView();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10.0),

                                      Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                                      InkWell(
                                        child: Container(
                                            width: deviceSize!.width / 2,
                                            height: deviceSize!.height / 18,
                                            margin: EdgeInsets.only(top: 25),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                color: Colors.black),
                                            child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 30.0,
                                                      width: 30.0,
                                                      decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/google.jpg'),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'Sign in with Google',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ))),
                                        onTap: () async {
                                          _onSignInWithGoogle(model)
                                              .then((result) {
                                            model.clearAllModels();
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                RouteName.Home,
                                                    (Route<dynamic> route) =>
                                                false);
                                          }).catchError((e) => print(e));
                                        },
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    model.state == ViewState.Busy
                        ? Utils.progressBar()
                        : Container(),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              model.clearAllModels();
              return false;
            },
          );
        });
  }
}

