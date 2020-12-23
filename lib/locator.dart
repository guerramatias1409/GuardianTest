import 'package:get_it/get_it.dart';
import 'package:guardiantest/Services/FirebaseAuthService.dart';
import 'package:guardiantest/Services/NotificationService.dart';

final locator = GetIt.instance;

void setupLocator() {
  print("setup locator");
  locator.registerSingleton(FirebaseAuthService());
  locator.registerSingleton<NotificationService>(NotificationService());
  print("end setup locator");
}