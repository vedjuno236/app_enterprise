// import 'dart:async';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:enterprise/components/constants/colors.dart';
// import 'package:enterprise/components/constants/key_shared.dart';
// import 'package:enterprise/components/models/attendance_sqlite_model/sqlite_model.dart';
// import 'package:enterprise/components/poviders/users_provider/users_provider.dart';
// import 'package:enterprise/components/services/api_service/enterprise_service.dart';
// import 'package:enterprise/components/services/databasehelper_sqlite/database_helper.dart';
// import 'package:enterprise/components/services/databasehelper_sqlite/network_service.dart';
// import 'package:enterprise/components/utils/date_format_utils.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../../components/constants/image_path.dart';
// import '../../../../components/constants/strings.dart';
// import '../../../../components/helpers/shared_prefs.dart';
// import '../../../../components/logger/logger.dart';
// import '../../../../components/poviders/home_provider/home_provider.dart';
// import '../../../../components/poviders/location_provider/location_provider.dart';
// import '../../../../components/router/router.dart';
// import '../../../../components/styles/size_config.dart';
// import '../../../../components/utils/dialogs.dart';
// import '../../../../components/utils/dio_exceptions.dart';
// import '../../../widgets/app_dialog/alerts_dialog.dart';
// import '../../../widgets/slide_checkin_checkout_widget/slide_to_perform.dart';

// class BoxCheckWidgets extends ConsumerStatefulWidget {
//   final SharedPrefs sharedPrefs;

//   const BoxCheckWidgets({super.key, required this.sharedPrefs});

//   @override
//   ConsumerState createState() => _BoxCheckWidgetsState();
// }

// class _BoxCheckWidgetsState extends ConsumerState<BoxCheckWidgets> {
//   late Position locationPosition;
//   bool isValidLocation = false;

//   @override
//   void initState() {
//     super.initState();
//     // _checkLocationPermission();
//     _determinePosition();
//     _getLocation();
//   }

//   Future<bool> _requestLocationPermission(BuildContext context) async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location service is disabled.')));
//       return false;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       if (Platform.isIOS) {
//         showCupertinoDialog(
//           context: context,
//           builder: (context) => AlertIOSDialog(
//             title: Text(
//               Strings.txtLocationPermissions.tr,
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(fontSize: SizeConfig.textMultiplier * 2),
//             ),
//             content: Text(
//               Strings.txtLocationPermissionssettings.tr,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall!
//                   .copyWith(fontSize: SizeConfig.textMultiplier * 2),
//             ),
//             onPressed: () {
//               openAppSettings();
//               Navigator.pop(context);
//             },
//           ),
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) => AlertCustomDialog(
//             title: Text(
//               Strings.txtLocationPermissions.tr,
//               style: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(fontSize: SizeConfig.textMultiplier * 2),
//             ),
//             content: Text(
//               Strings.txtLocationPermissionssettings.tr,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall!
//                   .copyWith(fontSize: SizeConfig.textMultiplier * 2),
//             ),
//             onTapOK: () {
//               openAppSettings();
//               Navigator.pop(context);
//             },
//           ),
//         );
//       }
//       return false;
//     }
//     await _getLocation();

//     return true;
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot  request permissions.');
//     }
//     await _getLocation();
//     return await Geolocator.getCurrentPosition();
//   }

//   Future<void> _checkLocationPermission() async {
//     try {
//       PermissionStatus status = await Permission.location.status;

//       if (status.isDenied) {
//         status = await Permission.location.request();
//         if (status.isDenied) {
//           logger.d("Location permission denied.");

//           return;
//         }
//       }

//       if (Platform.isAndroid) {
//         if (status.isGranted) {
//           PermissionStatus bgStatus = await Permission.locationAlways.status;
//           if (bgStatus.isDenied) {
//             bgStatus = await Permission.locationAlways.request();
//             if (bgStatus.isDenied) {
//               logger.d("Background location permission denied.");
//               return;
//             }
//           }
//         }
//       }
//       await _getLocation();
//     } catch (e) {
//       logger.e("Error checking location permission: $e");
//     }
//   }

//   Future<void> _getLocation() async {
//     // final isValidLocation = ref.watch(stateHomeProvider);
//     final isConnectedNetWork = await _networkService.isConnected();
//     try {
//       locationPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10),
//       ).timeout(const Duration(seconds: 10), onTimeout: () {
//         throw TimeoutException("Location retrieval timed out");
//       });

//       if (!mounted) return;

//       logger.i(
//           "User location: ${locationPosition.latitude}, ${locationPosition.longitude}");

//       final locationProvider =
//           ref.read(stateLocationProvider).getConditionSettingModel;
//       if (locationProvider?.data == null) {
//         logger.e("Invalid location data from provider");
//         return;
//       }

//       final data = locationProvider!.data!;
//       final targetLatitude = data.officeLat;
//       final targetLongitude = data.officeLong;
//       final allowedDistance = data.radius;

//       if (targetLatitude == null ||
//           targetLongitude == null ||
//           allowedDistance == null) {
//         logger.e(
//             "Missing location parameters: lat=$targetLatitude, long=$targetLongitude, radius=$allowedDistance");
//         return;
//       }

//       final distanceInMeters = Geolocator.distanceBetween(
//         locationPosition.latitude,
//         locationPosition.longitude,
//         targetLatitude,
//         targetLongitude,
//       );

//       isValidLocation = distanceInMeters <= allowedDistance;
//       logger.d(
//           "Valid location: $isValidLocation (Distance: $distanceInMeters meters)");
//     } catch (e) {
//       logger.e("Error getting location: $e");
//       rethrow;
//     }
//   }

//   final NetworkService _networkService = NetworkService();
//   Future<void> clockInOutService() async {
//     final isConnected = await _networkService.isConnected();
//     final userProvider = ref.read(stateUserProvider);
//     final userId = userProvider.getUserModel?.data?.id;

//     if (userId == null) {
//       logger.e("User ID is null");
//       return;
//     }
//     final keyword = isValidLocation ? "OFFICE" : "REMOTE";
//     String? imagePath;

//     if (!isValidLocation) {
//       final pickedFile =
//           await ImagePicker().pickImage(source: ImageSource.gallery);
//       imagePath = pickedFile?.path;
//       if (imagePath == null) {
//         logger.e("No image selected for remote clock-in");
//         return;
//       }
//     }

//     if (isConnected) {
//       try {
//         // Make API call with structured data
//         final response = await EnterpriseAPIService().saveAttendanceData(
//           type: keyword,
//           userID: userId,
//           latitude: locationPosition.latitude,
//           longitude: locationPosition.longitude,
//           imagePath: imagePath ?? '',
//           title: '',
//           createdAt: DateTime.now().toIso8601String(),
//         );

//         if (response['status'] != true) {
//           logger.e("Attendance save failed: ${response['message']}");
//           return;
//         }

//         final data = response['data'];
//         if (data == null) {
//           logger.e("No data returned from attendance API");
//           return;
//         }

//         final clockInTime = data['date'] as String? ?? '';
//         final typeClock = data['type_clock'] as String? ?? '';
//         final isLate = data['status_late'] as bool? ?? false;

//         context.push(
//           PageName.attendanceSuccess,
//           extra: {
//             'clockInTime': clockInTime,
//             'typeClock': typeClock,
//             'isLate': isLate,
//           },
//         );

//         logger.d("Attendance response: $response");

//         final homeNotifier = ref.read(stateHomeProvider.notifier);
//         typeClock == 'IN'
//             ? homeNotifier.setClockInTrue()
//             : homeNotifier.setClockInFalse();
//       } on DioException catch (e) {
//         if (context.mounted) {
//           await _saveToSQLite(
//             userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//             type: keyword,
//             latitude: locationPosition.latitude,
//             longitude: locationPosition.longitude,
//             imagePath: '',
//             title: '',
//           ).whenComplete(() => alertSuccessDialog(context));
//         }
//       } catch (e) {
//         if (context.mounted) {
//           await _saveToSQLite(
//             userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//             type: keyword,
//             latitude: locationPosition.latitude,
//             longitude: locationPosition.longitude,
//             imagePath: '',
//             title: '',
//           ).whenComplete(() => alertSuccessDialog(context));
//           // ignore: use_build_context_synchronously
//         }
//       }
//     } else {
//       await _saveToSQLite(
//         userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//         type: keyword,
//         latitude: locationPosition.latitude,
//         longitude: locationPosition.longitude,
//         imagePath: '',
//         title: '',
//       )
//           // ignore: use_build_context_synchronously
//           .whenComplete(() => alertSuccessDialog(context));
//     }
//   }

//   Future<void> _saveToSQLite({
//     required dynamic userId,
//     required String type,
//     required double latitude,
//     required double longitude,
//     String? imagePath,
//     String title = '',
//   }) async {
//     try {
//       final int userIdInt = userId is String ? int.parse(userId) : userId;

//       final attend = SQLiteModel(
//         idUser: userIdInt,
//         type: type,
//         latitude: latitude,
//         longitude: longitude,
//         imagePath: imagePath,
//         title: title,
//         createdAt: DateTime.now().toIso8601String(),
//         isSynced: false,
//       );
//       await DatabaseHelper.instance.createattend(attend);
//       logger.d("Attendance saved to SQLite successfully");
//     } catch (e) {
//       logger.e("Error saving to SQLite: $e");
//       rethrow;
//     }
//   }

//   Future<void> syncLocalAttendanceToAPI() async {
//     try {
//       final isConnected = await _networkService.isConnected();

//       if (!isConnected) {
//         logger.d("No internet connection available for syncing");
//         return;
//       }

//       // Get all unsynced attendance records from SQLite
//       final unsyncedRecords =
//           await DatabaseHelper.instance.getUnsyncedAttendance();
//       logger.d("Found ${unsyncedRecords.length} unsynced attendance records");

//       if (unsyncedRecords.isEmpty) {
//         logger.d("No unsynced attendance records to sync");
//         return;
//       }

//       // Process each unsynced record
//       for (final record in unsyncedRecords) {
//         try {
//           // Make API call with the stored data
//           final response = await EnterpriseAPIService().saveAttendanceData(
//               type: record.type!,
//               userID: record.idUser!,
//               latitude: record.latitude!,
//               longitude: record.longitude!,
//               imagePath: record.imagePath ?? '',
//               title: record.title!,
//               createdAt: record.createdAt);

//           if (response['status'] == true) {
//             // Update the record as synced in SQLite
//             await DatabaseHelper.instance.markAttendanceAsSynced(record.id!);
//             logger.d("Successfully synced attendance record ID: ${record.id}");

//             // Update UI state if needed
//             final homeNotifier = ref.read(stateHomeProvider.notifier);
//             final typeClock = response['data']?['type_clock'] as String? ?? '';
//             logger.d(typeClock);
//             typeClock == 'IN'
//                 ? homeNotifier.setClockInTrue()
//                 : homeNotifier.setClockInFalse();
//           } else {
//             logger.e(
//                 "API sync failed for record ID ${record.id}: ${response['message']}");
//           }
//         } catch (e) {
//           logger.e("Error syncing record ID ${record.id}: $e");
//           // Continue with next record instead of breaking the entire sync process
//         }
//         await DatabaseHelper.instance.deleteattend(record.id!);
//       }

//       logger.d("Attendance sync process completed");
//     } catch (e) {
//       logger.e("Sync process error: $e");
//     }
//   }

//   Future<void> alertSuccessDialog(
//     BuildContext context,
//   ) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertSuccessDialog(
//             title: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: const BoxDecoration(
//                 color: kO,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Bootstrap.check_circle_fill,
//                 color: Color(0xFFFFA232),
//                 size: SizeConfig.imageSizeMultiplier * 13,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'ທ່ານເຂົ້າວຽກສຳເລັດ !'.tr,
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium
//                       ?.copyWith(color: Color(0xFF6C7278)),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   '08:10 AM'.tr,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       color: Color(0xFFFF6563), fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   '19th November 2024'.tr,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge
//                       ?.copyWith(color: Color(0xFF6C7278)),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   'ກະລຸນາເຊື່ອມຕໍ່ອິນເຕີເນັດ ເພື່ອບັນທຶກການເຂົ້າວຽກ 🚀🌐 !'.tr,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge
//                       ?.copyWith(color: Color(0xFF6C7278)),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//             onTapOK: () {
//               context.pop();
//             },
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: SizeConfig.heightMultiplier * 25,
//       decoration: const BoxDecoration(
//         color: kTextWhiteColor,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: kGreyColor1,
//             blurRadius: 1.0,
//             spreadRadius: 1.0,
//           )
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // IconButton(
//             //     onPressed: () {
//             //       // syncLocalAttendanceToAPI();
//             //       alertSuccessDialog(context);
//             //     },
//             //     icon: Icon(Icons.add)),
//             Row(
//               children: [
//                 SvgPicture.asset(
//                   _getImagePath(),
//                   height: SizeConfig.imageSizeMultiplier * 10,
//                   width: SizeConfig.imageSizeMultiplier * 10,
//                 )
//                     .animate()
//                     .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
//                     .fadeIn(),
//                 SizedBox(width: SizeConfig.widthMultiplier * 4),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       Strings.txtToday,
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleLarge!
//                           .copyWith(fontSize: SizeConfig.textMultiplier * 2),
//                     ),
//                     Center(
//                       child: Text(
//                         DateFormatUtil.formatA(DateTime.now()),
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(fontSize: SizeConfig.textMultiplier * 2),
//                       ),
//                     ),
//                   ],
//                 )
//                     .animate()
//                     .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
//                     .fadeIn(),
//                 const Spacer(),
//                 const TimeDisplay()
//                     .animate()
//                     .slideY(duration: 1000.ms, curve: Curves.easeOutCubic)
//                     .fadeIn(),
//               ],
//             ),
//             SizedBox(height: SizeConfig.heightMultiplier * 2),
//           Expanded(
//                     child: SlideCheck(
//                         clockIn: ref.watch(stateHomeProvider).isClockedIn,
//                         callback: () async {
//                           // final isValidLocation =
//                           //     ref.watch(stateHomeProvider).isValidLocation;
//                           final hasPermission =
//                               await _requestLocationPermission(context);
//                           if (hasPermission) {
//                             if (isValidLocation) {
//                               await clockInOutService();
//                             } else {
//                               context.push(PageName.attendanceScreens);
//                             }
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content:
//                                       Text('Location permission is required.')),
//                             );
//                           }
//                         }),
//                   ).animate().scaleXY(
//                     begin: 0,
//                     end: 1,
//                     delay: 500.ms,
//                     duration: 500.ms,
//                     curve: Curves.easeInOutCubic)
//                 // : Padding(
//                 //     padding: const EdgeInsets.symmetric(vertical: 15),
//                 //     child: Shimmer.fromColors(
//                 //       baseColor: kGreyColor1,
//                 //       highlightColor: kGary,
//                 //       child: Container(
//                 //         width: double.infinity,
//                 //         height: SizeConfig.heightMultiplier * 7,
//                 //         padding: const EdgeInsets.all(8.0),
//                 //         decoration: BoxDecoration(
//                 //           color: kTextWhiteColor,
//                 //           borderRadius: BorderRadius.circular(50),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   )
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Optimized TimeDisplay widget
// class TimeDisplay extends StatelessWidget {
//   const TimeDisplay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Stream.periodic(const Duration(seconds: 1)),
//       builder: (context, snapshot) {
//         return Center(
//           child: Text(
//             DateFormatUtil.formats(DateTime.now()),
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(fontSize: SizeConfig.textMultiplier * 2.5),
//           ),
//         );
//       },
//     );
//   }
// }

// String _getImagePath() {
//   final now = TimeOfDay.now();
//   final currentMinutes = now.hour * 60 + now.minute;

//   /// 8:00 = 480 minutes, 17:00 = 1020 minutes

//   if (currentMinutes >= 480 && currentMinutes < 1020) {
//     return ImagePath.svgSunny;
//   } else {
//     return ImagePath.svgMoon;
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/utils/date_format_utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

import '../../../../components/constants/image_path.dart';
import '../../../../components/constants/strings.dart';
import '../../../../components/helpers/shared_prefs.dart';
import '../../../../components/logger/logger.dart';
import '../../../../components/poviders/home_provider/home_provider.dart';
import '../../../../components/poviders/location_provider/location_provider.dart';
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
    // _checkLocationPermission();

    preload();
    _determinePosition();
    _getLocation();
  }

  Future<bool> _requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Location service is disabled.')));
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
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(),
            ),
            content: Text(
              Strings.txtLocationPermissionssettings.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(),
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

  Future<void> _checkLocationPermission() async {
    try {
      PermissionStatus status = await Permission.location.status;

      if (status.isDenied) {
        status = await Permission.location.request();
        if (status.isDenied) {
          logger.d("Location permission denied.");

          return;
        }
      }

      if (Platform.isAndroid) {
        if (status.isGranted) {
          PermissionStatus bgStatus = await Permission.locationAlways.status;
          if (bgStatus.isDenied) {
            bgStatus = await Permission.locationAlways.request();
            if (bgStatus.isDenied) {
              logger.d("Background location permission denied.");
              return;
            }
          }
        }
      }
      await _getLocation();
    } catch (e) {
      logger.e("Error checking location permission: $e");
    }
  }

  Future<void> _getLocation() async {
    try {
      locationPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Location retrieval timed out");
      });

      if (!mounted) return;

      logger.i(
          "User location: ${locationPosition.latitude}, ${locationPosition.longitude}");

      final locationProvider =
          ref.read(stateLocationProvider).getConditionSettingModel;
      if (locationProvider?.data == null) {
        logger.e("Invalid location data from provider");
        return;
      }

      final data = locationProvider!.data!;
      final targetLatitude = data.officeLat;
      final targetLongitude = data.officeLong;
      final allowedDistance = data.radius;

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
      rethrow;
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

      logger.d("Attendance response: $response");

      final homeNotifier = ref.read(stateHomeProvider.notifier);
      typeClock == 'IN'
          ? homeNotifier.setClockInTrue()
          : homeNotifier.setClockInFalse();
    } on DioException catch (e) {
      logger
          .e("Network error during clock-in: ${DioExceptions.fromDioError(e)}");
      if (context.mounted) errorDialog(context: context, onError: e);
    } catch (e) {
      logger.e("Unexpected error during clock-in: $e");
      if (context.mounted) errorDialog(context: context, onError: e);
    }
  }

// Separate dialog builders for cleaner code

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SizeConfig.heightMultiplier * 19.5,
      decoration: const BoxDecoration(
        color: kTextWhiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: kGreyColor1,
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
              child: SlideCheck(
                  clockIn: ref.watch(stateHomeProvider).isClockedIn,
                  callback: () async {
                    // final isValidLocation =
                    //     ref.watch(stateHomeProvider).isValidLocation;
                    final hasPermission =
                        await _requestLocationPermission(context);
                    if (hasPermission) {
                      if (isValidLocation) {
                        await clockInOutService();
                      } else {
                        context.push(PageName.attendanceScreens);
                      }
                    } else {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //       content: Text('Location permission is required.')),
                      // );
                    }
                  }),
            ).animate().scaleXY(
                begin: 0,
                end: 1,
                delay: 500.ms,
                duration: 500.ms,
                curve: Curves.easeInOutCubic),
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
