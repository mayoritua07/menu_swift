import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swift_menu/constants/colors.dart';
import 'package:swift_menu/screens/menu_screen.dart';

import 'package:http/http.dart' as http;

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

  void fetchData(String businessID) async {
    try {
      String SCAN_API = "https://api.visit.menu/api/v1/business/${businessID}";
      final response = await http.get(Uri.parse(SCAN_API));
      final Map<String, dynamic> data = jsonDecode(response.body);

      ///check if response is valid
      final String? businessName = data["name"];
      final String? logoUrl = data["logoUrl"];

      if (businessName != null && logoUrl != null) {
        Navigator.of(context)
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
                  return MenuScreen(
                    businessID: businessID,
                    businessName: businessName,
                    logoUrl: logoUrl,
                  );
                }))
            .then((onValue) {
          setState(() {
            isScanningCode = false;
            showLoadingSpinner = false;
          });
        });
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              padding: EdgeInsets.all(14),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              duration: Duration(seconds: 2, milliseconds: 500),
              // backgroundColor: mainOrangeColor,
              content: Center(
                child: Text("Unable to load Data, Please scan again!",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white)),
              )),
        );
        setState(() {
          showLoadingSpinner = false;
        });
      }
    } catch (e) {
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
              child: Text("Unable to load Data, Please scan again!",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)),
            )),
      );
      setState(() {
        showLoadingSpinner = false;
      });
    }
  }

  void onQRDetected(capture) {
    if (!isScanningCode) {
      return;
    }
    isScanningCode = false;
    final List<Barcode> scannedQRcodes = capture.barcodes;
    final Barcode scannedQRcode = scannedQRcodes[0];

    String? businessID = scannedQRcode.rawValue;
    bool hasValidData = businessID != null;

    // businessID = "02c71f0e-4585-4798-8ab7-f19f366ccfc0";
    //The QR code is a link, http://vist.menu.....

    //Check if the first part is present, if it is, then it belongs to us, then we take the business id.

    if (hasValidData) {
      setState(() {
        showLoadingSpinner = true;
      });

      fetchData(businessID);
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
                        child: RotatedBox(
                          quarterTurns: isLandscape ? 3 : 0,
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
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          scanCode();
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
