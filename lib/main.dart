import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift_menu/screens/onboarding_screens.dart';
import 'package:swift_menu/screens/scan_screen.dart';
import 'package:swift_menu/widgets/completed_order_dialog.dart';

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

  //Simple flutter screen to show button to display completed order dialog ad wait for order
  @override
  Widget build(BuildContext context) {
    return isFirstTimeUsingApp!
        ? OnboardingScreen()
        :Scanscreen();
  }
}
//replace scaffold with the bar code scanner


// Scaffold(
//       body: Center(
//         child: ElevatedButton(
//             onPressed: () {
//               showCompletedOrderDialog(context);
//             },
//             child: Text("Show completed order dialog")),
//       ),
//     );