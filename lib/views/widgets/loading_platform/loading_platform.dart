import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../components/styles/size_config.dart';

class LoadingPlatform extends StatelessWidget {
  final Color? color;

  const LoadingPlatform({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhysicalModel(
          color: Theme.of(context).colorScheme.primary,
          // color: Colors.black87,
          clipBehavior: Clip.antiAlias,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: SpinKitCircle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 1,
        ),
        PhysicalModel(
          color: Theme.of(context).colorScheme.primary,
          // color: Colors.black87,
          clipBehavior: Clip.antiAlias,
          elevation: 10.0,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ກຳລັງໂຫຼດ",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.textMultiplier * 3.8),
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingPlatformV1 extends StatelessWidget {
  final Color? color;


  const LoadingPlatformV1({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: color ?? Colors.white,
      size: 40,
    );
  }
}

class LoadingPlatformV2 extends StatelessWidget {
  final Color? color;
  final double? size;
  

  const LoadingPlatformV2({
    super.key,
    this.color,
     this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: color ?? Colors.white,
      size: size ??40,
    );
  }
}
