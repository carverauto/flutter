import 'package:chaseapp/main_dev.dart' as dev;
import 'package:flutter_driver/flutter_driver.dart' as fdriver;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  final fdriver.FlutterDriver driver = await fdriver.FlutterDriver.connect();

  // final String data = await driver.requestData(EnvVaribales.devInstanceId);

  // print('PUsher key$data');

  testWidgets('failing test example', (WidgetTester tester) async {
    // expect(2 + 2, equals(5));
    // Setting up const/singletons like this will be redundant after refactoring
    // Prefs.init();
    // Initialize other services like SharedPreferances, etc and provide through providers

    dev.main();
    await tester.pumpAndSettle();

    // final PackageInfo info = await PackageInfo.fromPlatform();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // F.appFlavor = Flavor.DEV;

    // await setUpServices();

    print('1');
    // await tester.pumpWidget(
    //   ProviderScope(
    //     overrides: [
    //       appInfoProvider.overrideWithValue(info),
    //       sharedPreferancesProvider.overrideWithValue(prefs),
    //     ],
    //     observers: const [],
    //     child: const MyApp(),
    //   ),
    // );
    // print('2');
    // await tester.pump(const Duration(seconds: 1));
    // print('3');
    expect(1 + 1, 2);
  });
}
