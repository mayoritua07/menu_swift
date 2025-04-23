import 'package:flutter/material.dart';
import 'package:swift_menu/screens/menu_screen.dart';

class Scanscreen extends StatefulWidget {
  const Scanscreen({super.key});

  @override
  State<Scanscreen> createState() => _ScanscreenState();
}

class _ScanscreenState extends State<Scanscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 146,
                height: 154,
                decoration: BoxDecoration(
                 // border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset('assets/images/barcode.png')
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MenuScreen()));
                },
                child: Container(
                  height: 48,
                  width: 354,
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 16,
                    right: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xffF76B15)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code, size: 30, color: Color(0xfff76B15)),
                        const Text('Scan Barcode'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
