// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class AvatarWithBadge extends StatelessWidget {
  final String imageUrl;
  final IconData? badgeIcon;
  final Color? badgeColor;
  final double? size;

  const AvatarWithBadge(
      {Key? key,
      required this.imageUrl,
      this.badgeIcon,
      this.badgeColor,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Circular Avatar
        CircleAvatar(
          radius: size, // Adjust the size of the avatar
          backgroundImage: AssetImage(imageUrl),
        ),
        // Badge
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              badgeIcon,
              color: Colors.white,
              size: 18, // Adjust the icon size
            ),
          ),
        ),
      ],
    );
  }
}
