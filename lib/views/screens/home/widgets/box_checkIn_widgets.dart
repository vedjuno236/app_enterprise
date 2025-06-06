import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/poviders/check_boolean_in_out_provider/check_boolean_in_out_provider.dart';
import 'package:enterprise/components/poviders/home_provider/home_provider.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';

import '../../../../components/constants/image_path.dart';
import '../../../../components/constants/strings.dart';
import '../../../../components/helpers/shared_prefs.dart';
import '../../../../components/logger/logger.dart';
import '../../../../components/router/router.dart';
import '../../../../components/styles/size_config.dart';
import '../../../../components/utils/dialogs.dart';
import '../../../../components/utils/dio_exceptions.dart';
import '../../../widgets/app_dialog/alerts_dialog.dart';
import '../../../widgets/slide_checkin_checkout_widget/slide_to_perform.dart';

class BoxCheckWidgets extends ConsumerStatefulWidget {
  final SharedPrefs sharedPrefs;

  const BoxCheckWidgets({super.key, required this.sharedPrefs});

  @override
  ConsumerState createState() => _BoxCheckWidgetsState();
}

class _BoxCheckWidgetsState extends ConsumerState<BoxCheckWidgets> {
  late Position locationPosition;
  bool isValidLocation = false;

  /// rives
  Artboard? _riveArtboard;
  SMIInput<double>? _levelInput;
  StateMachineController? controller;
  Future<void> preload() async {
    try {
      final file = await RiveFile.asset('assets/rives/weather.riv');
      final artboard = file.mainArtboard;

      final animationController = SimpleAnimation('Animation 1');
      artboard.addController(animationController);
      animationController.isActive = true;

      if (mounted) {
        setState(() => _riveArtboard = artboard);
      }
    } catch (e) {
      print("Failed to load Rive file: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    //  _checkLocationPermission();
    preload();
    _determinePosition();
    _getLocation();
    fetchBooleanInOutApi();
  }

  ///ຕອນ clock
  Future<bool> _requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Location service is disabled!!!.')));
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => AlertIOSDialog(
            title: Text(
              Strings.txtLocationPermissions.tr,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
            content: Text(
              Strings.txtLocationPermissionssettings.tr,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(),
            ),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertCustomDialog(
            title: Text(
              Strings.txtLocationPermissions.tr,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
            content: Text(
              Strings.txtLocationPermissionssettings.tr,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(),
            ),
            onTapOK: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        );
      }
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (context) => AlertIOSDialog(
            title: Text(
              Strings.txtLocationPermissions.tr,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
            content: Text(
              Strings.txtLocationPermissionssettings.tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
            ),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertCustomDialog(
            title: Text(
              Strings.txtLocationPermissions.tr,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
            ),
            content: Text(
              Strings.txtLocationPermissionssettings.tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
            ),
            onTapOK: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        );
      }
      return false;
    }
    await _getLocation();

    return true;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot  request permissions.');
    }
    await _getLocation();
    return await Geolocator.getCurrentPosition();
  }

  ///  open loaction  enable ຕອນເປີດແອັບມາ
  Future<void> _getLocation() async {
    try {
      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger.e("Location services are disabled");
        if (mounted) {
          if (Platform.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (context) => AlertIOSDialog(
                title: Text(
                  Strings.txtLocationPermissions.tr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                ),
                content: Text(
                  Strings.txtLocationPermissionssettings.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                ),
                onPressed: () async {
                  // await Geolocator.openLocationSettings().whenComplete(() {
                  //   Navigator.pop(context);
                  // });
                  openAppSettings();
                  Navigator.pop(context);
                },
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertCustomDialog(
                title: Text(
                  Strings.txtLocationPermissions.tr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                ),
                content: Text(
                  Strings.txtLocationPermissionssettings.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                ),
                onTapOK: () async {
                  openAppSettings();
                  Navigator.pop(context);
                  //   await Geolocator.openLocationSettings().whenComplete(() {
                  //   Navigator.pop(context);
                  // });
                },
              ),
            );
          }
        }
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          logger.e("Location permission denied");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Location permission is required.")),
            );
          }
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        logger.e("Location permission permanently denied");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Please enable location in app settings.")),
          );
        }
        return;
      }

      // Get location
      locationPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      if (!mounted) return;

      logger.i(
          "User location: ${locationPosition.latitude}, ${locationPosition.longitude}");

      // final locationProvider =
      //     ref.read(stateLocationProvider).getConditionSettingModel;
      // if (locationProvider?.data == null) {
      //   logger.e("Invalid location data from provider");
      //   return;
      // }
      // final data = locationProvider!.data!;

      final lat = await sharedPrefs.getDoubleNow(KeyShared.keylat);
      final long = await sharedPrefs.getDoubleNow(KeyShared.keylong);
      final radius = await sharedPrefs.getDoubleNow(KeyShared.keyradius);

      final targetLatitude = lat;
      final targetLongitude = long;
      final allowedDistance = radius;
      if (targetLatitude == null ||
          targetLongitude == null ||
          allowedDistance == null) {
        logger.e(
            "Missing location parameters: lat=$targetLatitude, long=$targetLongitude, radius=$allowedDistance");
        return;
      }

      final distanceInMeters = Geolocator.distanceBetween(
        locationPosition.latitude,
        locationPosition.longitude,
        targetLatitude,
        targetLongitude,
      );

      isValidLocation = distanceInMeters <= allowedDistance;
      logger.d(
          "Valid location: $isValidLocation (Distance: $distanceInMeters meters)");
    } catch (e) {
      logger.e("Error getting location: $e");
      if (e is TimeoutException && mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text("Unable to get location. Please try again.")),
        // );
      }
    }
  }

  Future<void> clockInOutService() async {
    int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));
    try {
      final keyword = isValidLocation ? "OFFICE" : "REMOTE";
      String? imagePath;

      if (!isValidLocation) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        imagePath = pickedFile?.path;
        if (imagePath == null) {
          logger.e("No image selected for remote clock-in");
          return;
        }
      }

      // Make API call with structured data
      final response = await EnterpriseAPIService().saveAttendanceData(
          type: keyword,
          userID: userID,
          latitude: locationPosition.latitude,
          longitude: locationPosition.longitude,
          imagePath: imagePath ?? '',
          title: '',
          createdAt: DateTime.now().toIso8601String());

      if (response['status'] != true) {
        logger.e("Attendance save failed: ${response['message']}");
        return;
      }

      final data = response['data'];
      if (data == null) {
        logger.e("No data returned from attendance API");
        return;
      }

      final clockInTime = data['date'] as String? ?? '';
      final typeClock = data['type_clock'] as String? ?? '';
      final isLate = data['status_late'] as bool? ?? false;

      context.push(
        PageName.attendanceSuccess,
        extra: {
          'clockInTime': clockInTime,
          'typeClock': typeClock,
          'isLate': isLate,
        },
      );
    } on DioException catch (e) {
      logger
          .e("Network error during clock-in: ${DioExceptions.fromDioError(e)}");
      if (context.mounted) errorDialog(context: context, onError: e);
    } catch (e) {
      logger.e("Unexpected error during clock-in: $e");
      if (context.mounted) errorDialog(context: context, onError: e);
    }
  }

  late SharedPrefs sharedPrefs;
  late int userID;
  bool isLoading = false;
  bool isClockIn = false;

  Future fetchBooleanInOutApi() async {
    sharedPrefs = SharedPrefs();
    final userIdString = sharedPrefs.getStringNow(KeyShared.keyUserId);
    userID = int.tryParse(userIdString ?? '0') ?? 0;

    setState(() {
      isLoading = true;
    });

    try {
      final value =
          await EnterpriseAPIService().cllbooleancheckInOut(userid: userID);
      ref
          .read(stateCheckBooleanInOutModel)
          .setCheckBooleanInOutModel(value: value);
      logger.d(value);

      final typeClock = value['data']?['type_clock'] as String? ?? '';

      ref.read(stateHomeProvider.notifier).updateClockStatus(typeClock);
    } catch (onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.heightMultiplier * 19.5,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor,
            blurRadius: 1.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                if (_riveArtboard != null)
                  SizedBox(
                    height: SizeConfig.imageSizeMultiplier * 10,
                    width: SizeConfig.imageSizeMultiplier * 20,
                    child: Rive(
                      artboard: _riveArtboard!,
                      fit: BoxFit.fitWidth,
                    ),
                  ),

                // SvgPicture.asset(
                //   _getImagePath(),
                //   height: SizeConfig.imageSizeMultiplier * 10,
                //   width: SizeConfig.imageSizeMultiplier * 10,
                // )
                // .animate()
                // .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
                // .fadeIn(),
                // SizedBox(width: SizeConfig.widthMultiplier * 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.txtToday.tr,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kTextGrey,
                          fontSize: SizeConfig.textMultiplier * 2),
                    ),
                    Center(
                      child: Text(
                        DateFormatUtil.formatA(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: kTextGrey,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
                    .fadeIn(),
                const Spacer(),
                const TimeDisplay()
                    .animate()
                    .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
                    .fadeIn(),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            Expanded(
              // child: SlideCheck(
              //     clockIn: false,
              //     callback: () async {
              //       // final isValidLocation =
              //       //     ref.watch(stateHomeProvider).isValidLocation;
              //       final hasPermission =
              //           await _requestLocationPermission(context);
              //       if (hasPermission) {
              //         if (isValidLocation) {
              //           await clockInOutService();
              //         } else {
              //           context.push(PageName.attendanceScreens);
              //         }
              //       } else {
              //         // ScaffoldMessenger.of(context).showSnackBar(
              //         //   const SnackBar(
              //         //       content: Text('Location permission is required.')),
              //         // );
              //       }
              //     })).animate().scaleXY(
              child: SlideCheck(
                callback: () async {
                  final hasPermission =
                      await _requestLocationPermission(context);
                  if (!hasPermission) return;

                  if (isValidLocation) {
                    await clockInOutService();
                  } else {
                    if (mounted) {
                      context.push(PageName.attendanceScreens);
                    }
                  }
                  await fetchBooleanInOutApi();
                },
              ).animate().scaleXY(
                  begin: 0,
                  end: 1,
                  delay: 500.ms,
                  duration: 500.ms,
                  curve: Curves.easeInOutCubic),
            )
          ],
        ),
      ),
    );
  }
}

// Optimized TimeDisplay widget
class TimeDisplay extends StatelessWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Center(
          child: Text(
            DateFormatUtil.formats(DateTime.now()),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: SizeConfig.textMultiplier * 2.5,
                fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

String _getImagePath() {
  final now = TimeOfDay.now();
  final currentMinutes = now.hour * 60 + now.minute;

  /// 8:00 = 480 minutes, 17:00 = 1020 minutes

  if (currentMinutes >= 480 && currentMinutes < 1020) {
    return ImagePath.svgSunny;
  } else {
    return ImagePath.svgMoon;
  }
}
