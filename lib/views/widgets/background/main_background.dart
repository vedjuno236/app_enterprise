import 'package:enterprise/components/constants/colors.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';


class backGroundScreen extends StatelessWidget {
  // final double ballSize;
  // final double haloSize;
  // final Color ballColor;
  // final Color haloColor;

  const backGroundScreen({
    Key? key,
    // required this.ballSize,
    // required this.haloSize,
    // required this.ballColor,
    // required this.haloColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Halo effect
          Positioned(
            top: 0,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kYellowSecondColor.withOpacity(0.01), // Halo opacity
                boxShadow: [
                  BoxShadow(
                    color: kYellowSecondColor.withOpacity(0.4),
                    blurRadius: 300, // Blurry halo
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -20,
            child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kYellowSecondColor.withOpacity(0.01),
              boxShadow: [
                BoxShadow(
                  color: kYellowSecondColor.withOpacity(0.4),
                  blurRadius: 300,
                  spreadRadius: 100,
              )
              ]
            ),
          ))
        ],
      ),
    );
  }
}