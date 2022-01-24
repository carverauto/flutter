import 'dart:developer';
import 'dart:io';

import 'package:chaseapp/src/core/top_level_providers/firebase_providers.dart';
import 'package:chaseapp/src/modules/auth/view/providers/providers.dart';
import 'package:chaseapp/src/modules/signin/view/providers/providers.dart';
import 'package:chaseapp/src/shared/enums/social_logins.dart';
import 'package:chaseapp/src/shared/enums/view_state.dart';
import 'package:chaseapp/src/shared/util/helpers/deviceSize.dart';
import 'package:chaseapp/src/shared/util/helpers/multi_provider_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInView extends ConsumerWidget {
  LogInView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Future<void> signIn(
      Reader read, BuildContext context, SIGNINMETHOD signinmethod) async {
    try {
      await read(authRepoProvider).socialLogin(signinmethod);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          List<String> signInlist = await read(firebaseAuthProvider)
              .fetchSignInMethodsForEmail(e.email!);
          log(signInlist.toString());
          final SIGNINMETHOD? knownAuthProvider =
              await showDialog<SIGNINMETHOD?>(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "Account already created with different Provider. Please sign in with the provider you used to create the account at first. This will link your account with the provider you are currently using."),
                          Wrap(
                            children: signInlist.map<Widget>((provider) {
                              final SIGNINMETHOD knownAuthProvider =
                                  getSignInProviderHelper(provider);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, knownAuthProvider);
                                  },
                                  child: Text(knownAuthProvider.name),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  });

          if (knownAuthProvider != null) {
            try {
              await read(authRepoProvider)
                  .handleMutliProviderSignIn(knownAuthProvider, e.credential!);
            } catch (e) {
              log("Error", error: e);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
            }
          }

          break;
        default:
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          // backgroundColor: Color(0xFFE6E6E6),
          // backgroundColor: Vx.gray200,
          body: Stack(
            children: <Widget>[
              SizedBox(
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
                          image: AssetImage('assets/chaseapp.png'),
                        ),
                      ),
                    ),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10, right: 10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              children: <Widget>[
                                /*
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
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
                                            hintStyle: const TextStyle(fontSize: 15),
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                  model.passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: const Color(0xFFE6E6E6),
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
                                      const SizedBox( height: 10.0),

                                      Text.rich(
                                        TextSpan(
                                          text: "Don't have an account? ",
                                          style: const TextStyle(fontSize: 14.0),
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
                                      const SizedBox(height: 10.0),
                                       */
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        signIn(
                                          ref.read,
                                          context,
                                          SIGNINMETHOD.GOOGLE,
                                        );
                                      },
                                      child: Text("Continue With Google"),
                                    ),
                                    if (Platform.isIOS)
                                      ElevatedButton(
                                        onPressed: () {
                                          signIn(
                                            ref.read,
                                            context,
                                            SIGNINMETHOD.APPLE,
                                          );
                                        },
                                        child: Text("Continue With Apple"),
                                      ),
                                    ElevatedButton(
                                      onPressed: () {
                                        signIn(
                                          ref.read,
                                          context,
                                          SIGNINMETHOD.FACEBOOK,
                                        );
                                      },
                                      child: Text("Continue With Facebook"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        signIn(
                                          ref.read,
                                          context,
                                          SIGNINMETHOD.TWITTER,
                                        );
                                      },
                                      child: Text("Continue With Twitter"),
                                    ),
                                  ],
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
              Consumer(builder: (context, ref, _) {
                final state = ref.watch(signInProvider);
                return state == ViewState.Busy
                    ? const LinearProgressIndicator()
                    : Container();
              }),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
