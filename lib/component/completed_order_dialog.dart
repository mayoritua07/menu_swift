import 'package:flutter/material.dart';

class CompletedOrderDialog extends StatelessWidget {
  const CompletedOrderDialog({super.key});

  final double gap = 10;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(18),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Image.asset(
            "assets/images/Frame.png",
            width: (MediaQuery.sizeOf(context).width * 0.6),
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
                backgroundColor: Color.fromARGB(255, 247, 107, 21)),
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
          SizedBox(height: 10),
        ],
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