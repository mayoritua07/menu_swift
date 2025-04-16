import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swift_menu/screens/onboarding_screen_template.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  late SharedPreferences preferences;

  void loadSharedPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    loadSharedPreferences();
    super.initState();
  }

  void nextOnboardingScreen() {
    if (_controller.page == 2) {
      skipOnboardingScreen();
      return;
    }
    _controller.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void skipOnboardingScreen() async {
    preferences.setBool("isFirstTimeUsingApp", false);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          //######################## PUT BAR SCANNER PAGE HERE #########################
          return Scaffold(
            body: Center(
              child: Text("Place bar code scanner screen here"),
            ),
          ); //place bar code scanner here
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    //double height = MediaQuery.sizeOf(context).height;
    bool isLandscape =
        MediaQuery.maybeOf(context)!.orientation == Orientation.landscape;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
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
              ),
            ],
          ),
          Container(
              padding: isLandscape
                  ? EdgeInsets.only(left: width * 0.6)
                  : null, //equal to image size in landscape mode
              alignment: Alignment(0, 0.85),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: isLandscape ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  TextButton(
                    onPressed: skipOnboardingScreen,
                    child: Text(
                      "Skip",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    onDotClicked: (index) {
                      _controller.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    },
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: const Color.fromARGB(255, 247, 107, 21),
                    ),
                  ),
                  InkWell(
                    onTap: nextOnboardingScreen,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color.fromARGB(255, 247, 107, 21),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
