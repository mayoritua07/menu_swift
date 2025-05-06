import 'package:flutter/material.dart';

class MenuHeader extends StatefulWidget {
  const MenuHeader({super.key});

  @override
  State<MenuHeader> createState() => _MenuHeaderState();
}

class _MenuHeaderState extends State<MenuHeader> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double containerHeight = (isLandscape ? height * 0.35 : height * 0.18)
        .clamp(160, double.infinity);
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

// /////////// SHIMMER IMAGE ////////////////
        // Container(
        //   height: containerHeight,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   clipBehavior: Clip.hardEdge,
        //   child:
        // ),

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
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                stops: [0, 0.2, 0.45, 1],
                colors: [
                  const Color.fromARGB(80, 3, 2, 2),
                  const Color.fromARGB(50, 3, 2, 2),
                  const Color.fromARGB(30, 3, 2, 2),
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
              Text(
                "EXPERIENCE OUR",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text("UNIQUE BLEND",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white)),
              Text("Savor every taste",
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
