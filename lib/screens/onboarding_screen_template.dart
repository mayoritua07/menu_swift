import 'package:flutter/material.dart';
import 'package:swift_menu/constants/colors.dart';

class OnboardingScreenTemplate extends StatelessWidget {
  const OnboardingScreenTemplate(
      {super.key,
      required this.title,
      required this.details,
      required this.imagePath,
      this.skipOnboardingScreen,
      this.isLastPage = false});

  final String title;
  final String details;
  final String imagePath;
  final bool isLastPage;
  final void Function()? skipOnboardingScreen;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    double textScale = (width / 800).clamp(0.9, 1.4);
    bool isLandscape =
        MediaQuery.maybeOf(context)!.orientation == Orientation.landscape;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 0 : width * 0.03,
          vertical: isLandscape ? 0 : height * 0.08),
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: isLandscape
          ? Row(
              children: [
                SizedBox(
                  width: width * 0.6,
                  height: double.infinity,
                  // clipBehavior: Clip.hardEdge,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.horizontal(
                  //     // right: Radius.circular(30),
                  //     left: Radius.circular(30),
                  //   ),
                  // ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: width * 0.012,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                          textScaler: TextScaler.linear(textScale),
                        ),
                        SizedBox(height: 8),
                        Text(
                          details,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600, height: 1.8),
                          textScaler: TextScaler.linear(textScale),
                        ),
                        SizedBox(height: height * 0.05),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: isLastPage ? 1 : 0,
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.04),
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  // padding: EdgeInsets.symmetric(
                                  //     vertical: 8, horizontal: double.infinity),
                                  backgroundColor: mainOrangeColor),
                              onPressed: skipOnboardingScreen,
                              child: Text(
                                "Click to scan Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: width * 0.012),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 250,
                    ),
                    width: double.infinity,
                    height: height * 0.5,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: height * 0.08),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                    textScaler: TextScaler.linear(textScale),
                  ),
                  SizedBox(height: 6),
                  Text(
                    details,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600, height: 1.8),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(textScale),
                  ),
                  SizedBox(height: height * 0.035),
                  if (isLastPage)
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: isLastPage ? 1 : 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              backgroundColor: mainOrangeColor),
                          onPressed: skipOnboardingScreen,
                          child: Text(
                            "Click to scan Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: height * 0.06,
                  )
                ],
              ),
            ),
    );
  }
}
