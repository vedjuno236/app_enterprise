import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonPreviewMypost extends ConsumerWidget {
  final double width;
  final double height;
  final String count;
  final String title;
  final IconData? iconData;
  final bool isNew;
  final VoidCallback? onTap;

  const ButtonPreviewMypost(
      {super.key,
      required this.count,
      required this.title,
      this.iconData,
      required this.isNew,
      this.onTap,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(count),
                    Text(title),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
