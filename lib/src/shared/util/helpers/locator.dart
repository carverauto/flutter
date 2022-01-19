import 'package:chaseapp/src/modules/home/view/providers/home_view_model.dart';
import 'package:chaseapp/src/modules/signin/view/providers/sign_in_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setLocator() {
  locator.registerLazySingleton(() => SignInViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
}
