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
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 14, vertical: MediaQuery.sizeOf(context).height * 0.1),
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
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
