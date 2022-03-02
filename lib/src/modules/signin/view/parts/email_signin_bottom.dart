import 'dart:async';

import 'package:chaseapp/src/const/sizings.dart';
import 'package:chaseapp/src/shared/widgets/loaders/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailSignInBottom extends StatefulWidget {
  const EmailSignInBottom({
    Key? key,
    required TextEditingController textEditingController,
    required this.onTap,
    required this.isLoggingInWithEmail,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final TextEditingController _textEditingController;
  final Future<void> Function() onTap;
  final bool isLoggingInWithEmail;

  @override
  State<EmailSignInBottom> createState() => _EmailSignInBottomState();
}

class _EmailSignInBottomState extends State<EmailSignInBottom> {
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return isSending
        ? CircularAdaptiveProgressIndicatorWithBg()
        : widget.isLoggingInWithEmail
            ? SizedBox.shrink()
            : AnimatedBuilder(
                animation: widget._textEditingController,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).focusScopeNode.unfocus();
                    try {
                      setState(() {
                        isSending = true;
                      });
                      await widget.onTap();
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: kItemsSpacingSmallConstant,
                                ),
                                Expanded(
                                  child: Text(
                                    "Log in link has been sent to your email. Please check.",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    } on FirebaseAuthException catch (e) {
                      //TODO:logger log this
                      final message = e.code == "invalid-email"
                          ? "Invalid email address."
                          : "Something went wrong!";

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: kItemsSpacingSmallConstant,
                              ),
                              Text(
                                message,
                              ),
                            ],
                          ),
                        ),
                      );
                    } catch (e) {
                      //TODO:logger log this

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: kItemsSpacingSmallConstant,
                              ),
                              Text(
                                "Something went wrong. Please try agin later.",
                              ),
                            ],
                          ),
                        ),
                      );
                    } finally {
                      setState(() {
                        isSending = false;
                      });
                    }
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                builder: (context, child) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: widget._textEditingController.text.isNotEmpty
                        ? child!
                        : SizedBox.shrink(),
                  );
                },
              );
  }
}
