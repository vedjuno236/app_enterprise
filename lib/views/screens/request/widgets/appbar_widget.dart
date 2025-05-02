// // File: package:enterprise/views/widgets/appbar/appbar_widget.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../components/constants/colors.dart'; // Adjust the path as needed
// import '../../../../components/constants/strings.dart'; // Adjust the path as needed

// class AppbarWidget extends ConsumerWidget implements PreferredSizeWidget {
//   // Constructor for AppbarWidget
//   const AppbarWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return AppBar(
//       elevation: 0,
//       title: const Text(Strings.txtRequest), // Title of the AppBar
//       actions: [
//         GestureDetector(
//           onTap: () {
//             // buildShowModalBottomSheet(context); // Uncomment to use
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: kBack, // Background color for the icon container
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.add, // Icon displayed in the AppBar
//                 color: kTextWhiteColor, // Icon color
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
