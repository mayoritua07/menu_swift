import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double containerHeight = (isLandscape ? height * 0.35 : height * 0.2)
        .clamp(170, double.infinity);
    return Stack(
      children: [
        // Background Image
        Container(
          height: containerHeight, // Adjust as needed
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/Restaurant Image.png'), // Ensure correct path
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Bottom Overlay (Semi-Transparent)
        Positioned(
          // bottom: 0,
          // left: 0,
          // top: 0,
          // right: 200,
          child: Container(
            height: containerHeight, // Covers the bottom part
            width: double.infinity,
            decoration: BoxDecoration(
              // color: const Color.fromARGB(
              //     99, 63, 63, 63), // Semi-transparent color
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              gradient: LinearGradient(
                stops: [0.2, 0.35, 1],
                colors: [
                  const Color.fromARGB(88, 3, 2, 2),
                  Colors.transparent,
                  Colors.transparent
                ],
              ),
            ),
          ),
        ),

        // Text Content (On Top of Overlay)
        Positioned(
          left: 20,
          bottom: 20, // Adjust for positioning inside overlay
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("EXPERIENCE OUR",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                      )),
              Text("UNIQUE BLEND",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
              Text("Savor every taste",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      )),
            ],
          ),
        ),
      ],
    );
  }
}
