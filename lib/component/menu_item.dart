import 'package:flutter/material.dart';
import 'package:swift_menu/constants/colors.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final VoidCallback onTap;
  final String imagePath;
  final bool isAvailable;

  const MenuItem(
      {super.key,
      required this.title,
      required this.description,
      required this.price,
      required this.onTap,
      required this.imagePath,
      required this.isAvailable});

  @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     child: Container(
  //       width: double.infinity,
  //       height: 132,
  //       padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
  //       decoration: BoxDecoration(
  //         color: const Color(0xffFAFAFA),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   title,
  //                   style: const TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color(0xff333333)),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   description,
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: greyTextColor,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   price,
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     color: greyTextColor,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             width: 100,
  //             child: Stack(
  //               alignment: Alignment.bottomCenter,
  //               children: [
  //                 // Image Card
  //                 Positioned(
  //                   top: 0,
  //                   child: Container(
  //                     width: 80,
  //                     height: 60,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(8),
  //                       boxShadow: const [
  //                         BoxShadow(
  //                           color: Colors.black12,
  //                           blurRadius: 2,
  //                           offset: Offset(0, 1),
  //                         ),
  //                       ],
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(8),
  //                       child: Image.asset(
  //                         imagePath,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 // Button overlapping the image
  //                 Positioned(
  //                   bottom: 0,
  //                   child: SizedBox(
  //                     width: 80,
  //                     child: ElevatedButton(
  //                       onPressed: onTap,
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 16,
  //                           vertical: 8,
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         'Add +',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 132,
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
        decoration: BoxDecoration(
          color: isAvailable
              ? const Color(0xffFAFAFA)
              : Color.fromARGB(99, 175, 175, 175),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title[0].toUpperCase() +
                        title
                            .substring(
                              1,
                            )
                            .toLowerCase(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: greyTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      color: greyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Image Card
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 80,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imagePath.startsWith('http')
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      color: mainOrangeColor,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  );
                                },
                              )
                            : Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  // Button overlapping the image
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Add +',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isAvailable)
                    Positioned(
                        top: 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text("Out of stock",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11)),
                        ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
