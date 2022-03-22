import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../../const/sizings.dart';
import '../../../../shared/widgets/loaders/loading.dart';

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
  final Logger logger = Logger('EmailSignIn');

  @override
  Widget build(BuildContext context) {
    return isSending
        ? const CircularAdaptiveProgressIndicatorWithBg()
        : widget.isLoggingInWithEmail
            ? const SizedBox.shrink()
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
                              children: const [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: kItemsSpacingSmallConstant,
                                ),
                                Expanded(
                                  child: Text(
                                    'Log in link has been sent to your email. Please check.',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    } on FirebaseAuthException catch (e, stk) {
                      if (e.code != 'invalid-email') {
                        logger.severe(
                          'Failed To Send Email Signin Link',
                          e,
                          stk,
                        );
                      }

                      final String message = e.code == 'invalid-email'
                          ? 'Invalid email address.'
                          : 'Something went wrong!';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.info,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: kItemsSpacingSmallConstant,
                              ),
                              Text(
                                message,
                              ),
                            ],
                          ),
                        ),
                      );
                    } catch (e, stk) {
                      //TODO:logger log this
                      logger.severe('Failed To Send Email Signin Link', e, stk);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: const [
                              Icon(
                                Icons.info,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: kItemsSpacingSmallConstant,
                              ),
                              Expanded(
                                child: Text(
                                  'Something went wrong. Please try again later.',
                                ),
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
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: widget._textEditingController.text.isNotEmpty
                        ? child!
                        : const SizedBox.shrink(),
                  );
                },
              );
  }
}
