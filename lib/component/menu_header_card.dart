import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 180, // Adjust as needed
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage('assets/images/Restaurant Image.png'), // Ensure correct path
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Bottom Overlay (Semi-Transparent)
        Positioned(
          bottom: 0,
          left: 0,
          top: 0,
          right: 200,
          child: Container(
            height: 70, // Covers the bottom part
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent, // Semi-transparent color
              //borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Helvetica Neue',
                ),
              ),
              Text(
                "UNIQUE BLEND",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Helvetica Neue',
                ),
              ),
              Text(
                "Savor every taste",
                style: TextStyle(fontSize: 16, color: Colors.white70,fontFamily: 'Helvetica Neue',),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
