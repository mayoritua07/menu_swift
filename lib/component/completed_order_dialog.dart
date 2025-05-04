import 'package:flutter/material.dart';
import 'package:swift_menu/constants/colors.dart';
// import 'package:swift_menu/main.dart';

class CompletedOrderDialog extends StatelessWidget {
  const CompletedOrderDialog({super.key});

  final double gap = 10;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isLandscape =
        MediaQuery.maybeOf(context)!.orientation == Orientation.landscape;
    return AlertDialog(
      contentPadding: EdgeInsets.all(18),
      backgroundColor: Colors.white,
      content: SizedBox(
        // width: isLandscape ? width * 0.3 : null,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 10),
              Image.asset(
                "assets/images/Frame.png",
                width: isLandscape ? width * 0.17 : width * 0.32,
                fit: BoxFit.cover,
              ),
              SizedBox(height: gap),
              Text(
                "Your order has been confirmed.",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: gap),
              Text(
                "Sit back and relax, as your order is on it's way to you",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: gap),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                    backgroundColor: mainOrangeColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}


// Container(
//         width: MediaQuery.sizeOf(context).width * 0.85,
//         // height: MediaQuery.sizeOf(context).height * 0.5,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.all(
//             Radius.circular(20),
//           ),
//         ),
//         child: ),