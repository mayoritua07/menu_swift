import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/screens/menu_screen.dart';

String baseUrl = "";

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

  Future<Map<String, String>> fetchData(String businessID) async {
    return {};
  }

  void onQRDetected(capture) {
    if (!isScanningCode) {
      return;
    }
    final List<Barcode> scannedQRcodes = capture.barcodes;
    final Barcode scannedQRcode = scannedQRcodes[0];

    String? data = scannedQRcode.rawValue;
    bool hasValidData = data != null;

    if (hasValidData) {
      setState(() {
        showLoadingSpinner = true;
      });

      fetchData(data).then((onValue) {
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
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            padding: EdgeInsets.all(14),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            duration: Duration(seconds: 2, milliseconds: 500),
            // backgroundColor: mainOrangeColor,
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
    double width = MediaQuery.sizeOf(context).width;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double scannerWidth = isLandscape ? height * 0.55 : width * 0.75;
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
                        backgroundColor: mainOrangeColor,
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
                        width: scannerWidth,
                        height: scannerWidth,
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
                        ///////////////////////temeporary code for now.....
                        onDoubleTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 300),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: Tween(begin: 0.65, end: 1.0)
                                      .animate(animation),
                                  child: child,
                                );
                              },
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return MenuScreen();
                              }));
                        },
                        child: Container(
                          // height: 55,
                          constraints: BoxConstraints(
                            minWidth: 280,
                          ),
                          width: scannerWidth,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: mainOrangeColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code,
                                  size: 30, color: mainOrangeColor),
                              SizedBox(width: 4),
                              Text(
                                'Scan QRcode',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: mainOrangeColor),
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
