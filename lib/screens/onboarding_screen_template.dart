import 'package:flutter/material.dart';

class OnboardingScreenTemplate extends StatelessWidget {
  const OnboardingScreenTemplate(
      {super.key,
      required this.title,
      required this.details,
      required this.imagePath});

  final String title;
  final String details;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    bool isLandscape =
        MediaQuery.maybeOf(context)!.orientation == Orientation.landscape;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 0 : width * 0.02,
          vertical: isLandscape ? 0 : height * 0.09),
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: isLandscape
          ? Row(
              children: [
                Container(
                  width: width * 0.6,
                  height: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      // right: Radius.circular(30),
                      left: Radius.circular(30),
                    ),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: width * 0.01),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 12),
                      Text(
                        details,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: null,
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
                SizedBox(height: height * 0.1),
                Text(title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 12),
                Text(
                  details,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
