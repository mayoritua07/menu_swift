import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swift_menu/screens/menu_screen.dart';

class Scanscreen extends StatefulWidget {
  const Scanscreen({super.key});

  @override
  State<Scanscreen> createState() => _ScanscreenState();
}

class _ScanscreenState extends State<Scanscreen> {
  MobileScannerController controller = MobileScannerController(
      autoStart: true, detectionSpeed: DetectionSpeed.normal);
  bool isScanningCode = false;
  bool showLoadingSpinner = false;

  @override
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onQRDetected(capture) {
    if (!isScanningCode) {
      return;
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    final List<Barcode> scannedQRcodes = capture.barcodes;
    final Barcode scannedQRcode = scannedQRcodes[0];

    String? data = scannedQRcode.rawValue;
    bool hasValidData = data != null;

    if (hasValidData) {
      setState(() {
        showLoadingSpinner = true;
      });
      //fetch data then go to the next page
      Future.delayed(Duration(seconds: 3)).then((onValue) {
        if (context.mounted) {
          return Navigator.of(context)
              .push(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 300),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: Tween(begin: 0.65, end: 1.0).animate(animation),
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return MenuScreen();
                  }))
              .then((onValue) {
            setState(() {
              isScanningCode = false;
              showLoadingSpinner = false;
            });
          });
        }
      });
    } else {
      isScanningCode = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            padding: EdgeInsets.all(14),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            duration: Duration(seconds: 2, milliseconds: 500),
            backgroundColor: const Color.fromARGB(255, 247, 107, 21),
            content: Center(
              child: Text("Invalid QR code. Please Try again!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)),
            )),
      );
    }
  }

  void scanCode() {
    setState(() {
      isScanningCode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: height),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: showLoadingSpinner
                  ? [
                      CircularProgressIndicator.adaptive(
                        backgroundColor:
                            const Color.fromARGB(255, 247, 107, 21),
                      ),
                      SizedBox(height: 8),
                      Text("Loading Digital Menu")
                    ]
                  : [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        constraints: BoxConstraints(
                          minWidth: 280,
                          minHeight: 280,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: height * 0.5,
                        height: height * 0.5,
                        child: MobileScanner(
                          controller: controller,
                          onDetect: onQRDetected,
                          placeholderBuilder:
                              (BuildContext context, Widget? child) {
                            return Image.asset(
                              'assets/images/barcode.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          scanCode();
                        },
                        child: Container(
                          // height: 55,
                          constraints: BoxConstraints(
                            minWidth: 280,
                          ),
                          width: height * 0.5,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xffF76B15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code,
                                  size: 30, color: Color(0xfff76B15)),
                              SizedBox(width: 4),
                              Text(
                                'Scan QRcode',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Color(0xfff76B15)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
