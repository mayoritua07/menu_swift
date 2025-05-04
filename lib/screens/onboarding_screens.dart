import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/screens/onboarding_screen_template.dart';
import 'package:swift_menu/screens/scan_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  late SharedPreferences preferences;
  int lastPageNumber = 2;
  bool isLastPage = false;

  void loadSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void nextOnboardingScreen() {
    if (_pageController.page == lastPageNumber) {
      skipOnboardingScreen();
      return;
    }
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void skipOnboardingScreen() async {
    preferences.setBool("isFirstTimeUsingApp", false);
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween(begin: 0.65, end: 1.0).animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          //####################O replace Scaffold with bar scanner page
          return Scanscreen();
        }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    // double height = MediaQuery.sizeOf(context).height;
    bool isLandscape =
        MediaQuery.maybeOf(context)!.orientation == Orientation.landscape &&
            width > 500;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int pageNumber) {
              setState(() {
                isLastPage = pageNumber == lastPageNumber;
              });
            },
            children: [
              OnboardingScreenTemplate(
                title: "SCAN & GO",
                details:
                    "Browse a live menu with real-time updates, mouthwatering images, and clear descriptions. Pick what you love",
                imagePath: "assets/images/Onboarding/onboarding_1.png",
              ),
              OnboardingScreenTemplate(
                title: "NO APPS, NO WAIT-JUST SCAN!",
                details:
                    "Browse a live menu with real-time updates, mouth-watering images, and clear descriptions. Pick what you love",
                imagePath: "assets/images/Onboarding/onboarding_2.png",
              ),
              OnboardingScreenTemplate(
                title: "ONE TAP & YOU ARE DONE",
                details:
                    "Select your meal, customize it, and send your order straight to the kitchen. Simple, fast, and effortless!",
                imagePath: "assets/images/Onboarding/onboarding_3.png",
                isLastPage: isLastPage,
                skipOnboardingScreen: skipOnboardingScreen,
              ),
            ],
          ),
          Container(
            padding: isLandscape
                ? EdgeInsets.only(
                    left: width * 0.6) //equal to image size in landscape mode
                : null,
            alignment: Alignment(0, 0.88),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // mainAxisSize: isLandscape ? MainAxisSize.min : MainAxisSize.max,
                    children: [
                      if (!isLastPage)
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: isLastPage ? 0 : 1,
                          child: TextButton(
                            onPressed: skipOnboardingScreen,
                            child: Text(
                              "Skip",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                              // textScaler: TextScaler.linear(textScale),x
                            ),
                          ),
                        ),
                      SmoothPageIndicator(
                        controller: _pageController,
                        onDotClicked: (index) {
                          _pageController.animateToPage(index,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        count: 3,
                        effect: ExpandingDotsEffect(
                          spacing: 12,
                          expansionFactor: 2,
                          radius: 10,
                          dotHeight: 10,
                          dotWidth: 10,
                          strokeWidth: 0.8,
                          dotColor: const Color.fromARGB(201, 254, 233, 221),
                          activeDotColor: mainOrangeColor,
                        ),
                      ),
                      if (!isLastPage)
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 300),
                          opacity: isLastPage ? 0 : 1,
                          child: InkWell(
                            onTap: nextOnboardingScreen,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: mainOrangeColor,
                              child: Icon(
                                Platform.isIOS
                                    ? Icons.arrow_forward_ios_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 23,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
