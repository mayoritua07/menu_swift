import 'package:flutter/material.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/main.dart';

bool canSkipUpdate = true;

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 2,
      ),
    );

    animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double radius = isLandscape ? height * 0.4 : width * 0.4;

    final List<Widget> children = [
      SizedBox(height: height * 0.05),
      RotationTransition(
        turns:
            CurvedAnimation(parent: animationController, curve: Curves.linear),
        child: Image(
          color: mainOrangeColor,
          width: radius,
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/images/splash_icon.png",
          ),
        ),
        // CircleAvatar(
        // backgroundColor: Colors.transparent,
        // backgroundImage: AssetImage("assets/images/Background/bg3.png"),
        // radius: radius,
        // child: ),
      ),
      SizedBox(height: height * 0.05),

      // Text(
      //   "A new update is available",
      //   style: Theme.of(context)
      //       .textTheme
      //       .titleLarge!
      //       .copyWith(color: Colors.white),
      // ),
      // SizedBox(height: height * 0.1),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainOrangeColor,
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            onPressed: openStoreToUpdate,
            child: Text(
              "Update Available!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Download the latest version to enjoy new yummy\nfeatures and deals.",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: const Color.fromARGB(255, 33, 23, 52)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: height * 0.08),
          if (canSkipUpdate)
            TextButton(
              child: Text(
                "Skip Update",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
        ],
      )
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 222, 203),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("assets/images/Background/bg3.png"),
        //       fit: BoxFit.cover),
        // ),
        child: isLandscape
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: children,
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children),
      ),
    );
  }
}

bool checkForUpdate() {
  //return false for no update, return true if there is an available update
  //force update when it is long overdue
  canSkipUpdate = true;
  return false;
}

void openStoreToUpdate() {}
