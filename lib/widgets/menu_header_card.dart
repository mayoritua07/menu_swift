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
              image: AssetImage('assets/food.png'), // Ensure correct path
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Bottom Overlay (Semi-Transparent)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 70, // Covers the bottom part
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x663D0466), // Semi-transparent color
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
                "Swoop Dining",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Best Naija Cuisine",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
