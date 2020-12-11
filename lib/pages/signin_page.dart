import 'dart:ui';
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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isSignIn = false;
  bool google = false;


  // text field state
  String email = '';
  String name;
  String imageUrl;
  String password = '';
  String error = '';

  _onSignIn(SignInViewModel model, String service) async {
    model.state = ViewState.Busy;
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (service == 'google') {
        // await _auth.signInWithEmailAndPassword(email, password).then((
        await _auth.signInWithGoogle().then((
            result) async {
          if (result != null) {
            QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(result);

            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs[0].data()['fullName']
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
      } // google

      // Sign-in with e-mail
      if (service == 'email') {
        await _auth.signInWithEmailAndPassword(email, password).then((
            result) async {
          if (result != null) {
            QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(
                email);

            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(
                userInfoSnapshot.docs[0].data()['fullName']
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
      }
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
                backgroundColor: Color(0xFFE6E6E6),
                // backgroundColor: Vx.gray200,
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: 410,
                      width: 430,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize.height / 2.4,
                            width: deviceSize.width / 3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                AssetImage('assets/chaseapplogo-512.png'),
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
                                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
                                          },
                                          onChanged: (val) {
                                            setState(() {
                                              email = val;
                                            });
                                          },
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          decoration: InputDecoration(
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
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter
                                                .singleLineFormatter,
                                          ],
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
                                          validator: (val) => val.length < 6 ? 'Password not strong enough': null,
                                          obscureText: !model.passwordVisible,
                                          onChanged: (val) {
                                            setState(() {
                                              password = val;
                                            });
                                          },
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            hintText: "Password",
                                            contentPadding: EdgeInsets.fromLTRB(
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
                                                  _onSignIn(model,"email");
                                                }),
                                          ),
                                          cursorColor: Colors.black,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter
                                                .singleLineFormatter,
                                          ],
                                        ),
                                      ),

                                      SizedBox( height: 10.0),

                                      Text.rich(
                                        TextSpan(
                                          text: "Don't have an account? ",
                                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Register here',
                                              style: TextStyle(
                                                  color: Colors.white,
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
                                            width: deviceSize.width / 2,
                                            height: deviceSize.height / 18,
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
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/google.jpg'),
                                                            fit: BoxFit.cover),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Text(
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
                                          _onSignIn(model,"google")
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
                                      SizedBox(
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

