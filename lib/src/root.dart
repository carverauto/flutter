import 'package:chaseapp/src/routes/routes.dart';
import 'package:chaseapp/src/core/top_level_providers/nodle_provider.dart';
import 'package:chaseapp/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(nodleProvider.notifier).initializeNodle();
    return MaterialApp(
      title: 'ChaseApp',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.onGenerateRoute,
      theme: getThemeData(context),
    );
  }
}
