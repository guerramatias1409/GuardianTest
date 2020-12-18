import 'package:get_it/get_it.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';

final locator = GetIt.instance;

void setupLocator() {
  print("setup locator");
  locator.registerSingleton(FirebaseAuthService());
  print("end setup locator");
}