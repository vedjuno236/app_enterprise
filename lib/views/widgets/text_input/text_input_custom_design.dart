// import 'package:flutter/material.dart';

// class TextFieldContainer extends StatelessWidget {
//   final Widget child;
//   final Color borderColor;

//   const TextFieldContainer({
//     super.key,
//     required this.child,
//     this.borderColor = const Color(0xFFFFFFFF), // Default border color
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(
//         vertical: 5,
//       ),
//       decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.white60.withOpacity(0.5),
//               blurRadius: 10,
//             ),
//           ],
//           border: Border.all(
//             color: borderColor, // Use the passed color
//             width: 0.5, // Set the border width
//           ),
//           borderRadius: BorderRadius.circular(15),
//           color: const Color(0xFFFFFFFF)),
//       child: child,
//     );
//   }
// }
