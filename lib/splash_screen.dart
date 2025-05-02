import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'components/constants/key_shared.dart';
import 'components/helpers/shared_prefs.dart';
import 'components/poviders/users_provider/users_provider.dart';
import 'components/router/router.dart';
import 'components/services/api_service/enterprise_service.dart';
import 'components/utils/dio_exceptions.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    checkStatusAuth();
  }

  Future<void> checkStatusAuth() async {
      Future.delayed(Duration.zero, () {
      directionScreenFunction();
    });
  }

  SharedPrefs sharedPrefs = SharedPrefs();

  void directionScreenFunction() async {
    final token = sharedPrefs.getStringNow(KeyShared.keyToken);

    if (token != null && token.isNotEmpty) {
      context.go(PageName.navigatorBarScreenRoute);
    } else {
      context.go(PageName.login);
    }
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: SvgPicture.network(
            "https://ncc.com.la/assets/ncc-B1qdPnNq.svg",
          ),
        ).animate().scaleXY(
            begin: 0,
            end: 1,
            delay: 1000.ms,
            duration: 1000.ms,
            curve: Curves.easeInOutCubic),
      ),
    );
  }
}
