import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift_menu/component/completed_order_dialog.dart';
import 'package:swift_menu/screens/menu_screen.dart';
import 'package:swift_menu/screens/onboarding_screens.dart';
import 'package:swift_menu/screens/scan_screen.dart';

bool? isFirstTimeUsingApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  isFirstTimeUsingApp = preferences.getBool("isFirstTimeUsingApp") ?? true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "HelveticaNeue",
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 247, 107, 21),
        ),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  void showCompletedOrderDialog(context) {
    ///function to show completed order Dialog
    showDialog(
        context: context,
        builder: (ctx) {
          return CompletedOrderDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return isFirstTimeUsingApp! ? OnboardingScreen() : MenuScreen();
  }
}
