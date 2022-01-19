import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chaseapp/src/shared/util/helpers/helper_functions.dart';
import 'package:chaseapp/src/modules/home/view/pages/home_page.dart';
import 'package:chaseapp/src/modules/auth/data/auth_service.dart';
import 'package:chaseapp/src/const/constants.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  const RegisterPage({required this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  _onRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .registerWithEmailAndPassword(fullName, email, password)
          .then((result) async {
        if (result != null) {
          /*
          var status = await Permission.storage.status;
          if (status.isUndetermined) {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
            ].request();
            print(statuses[Permission.storage]); // it should print PermissionStatus.granted
          }
          if (status.isGranted) {
            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(fullName);
          } else {
            setState(() {
              error = 'Must grant permissions to application!';
              _isLoading = false;
            });
          }
           */

          var status = await Permission.storage.status;
          if (status.isDenied) {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
            ].request();
            print(statuses[Permission.storage]);
          }

          if (status.isGranted) {
            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserEmailSharedPreference(email);
            await HelperFunctions.saveUserNameSharedPreference(fullName);
          } else {
            setState(() {
              error = 'Must grant permissions to application!';
              _isLoading = false;
            });
          }

          print("Registered");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          setState(() {
            error = 'Error while registering the user!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            body: Form(
                key: _formKey,
                child: Container(
                  color: Colors.black,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 80.0),
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text("Create or Join Groups",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 30.0),
                          const Text("Register",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0)),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Full Name'),
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email'),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                          const SizedBox(height: 15.0),
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password'),
                            validator: (val) => val!.length < 6
                                ? 'Password not strong enough'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Text('Register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                onPressed: () {
                                  _onRegister();
                                }),
                          ),
                          const SizedBox(height: 10.0),
                          Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Sign In',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.toggleView();
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0)),
                        ],
                      ),
                    ],
                  ),
                )),
          );
  }
}
