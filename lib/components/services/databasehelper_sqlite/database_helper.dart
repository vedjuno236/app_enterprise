import 'package:enterprise/components/models/attendance_sqlite_model/sqlite_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE attendance ADD COLUMN isSynced INTEGER NOT NULL DEFAULT 0');
        }
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idUser INTEGER NOT NULL,
        type TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        imagePath TEXT,
        title TEXT,
        createdAt TEXT NOT NULL,
        isSynced INTEGER NOT NULL
      )
    ''');
  }

  // Create (Insert)
  Future<int> createattend(SQLiteModel attend) async {
    final db = await instance.database;
    return await db.insert('attendance', attend.toMap());
  }

  // Read (Query)
  Future<List<SQLiteModel>> getattendance() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('attendance');
    return List.generate(maps.length, (i) {
      return SQLiteModel.fromMap(maps[i]);
    });
  }



  // Delete
  Future<int> deleteattend(int id) async {
    final db = await instance.database;
    return await db.delete(
      'attendance',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get unsynced attendance records
  Future<List<SQLiteModel>> getUnsyncedAttendance() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'isSynced = ?',
      whereArgs: [0], // 0 represents false
    );
    return List.generate(maps.length, (i) {
      return SQLiteModel.fromMap(maps[i]);
    });
  }

  // Update sync status of a record

  Future<int> markAttendanceAsSynced(int id) async {
    final db = await instance.database;
    return await db.update(
      'attendance',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'attendance.db');
    await deleteDatabase(path);
    print('Database deleted');
  }
}






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
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../../../../components/constants/image_path.dart';
// import '../../../../components/constants/strings.dart';
// import '../../../../components/helpers/shared_prefs.dart';
// import '../../../../components/logger/logger.dart';
// import '../../../../components/poviders/home_provider/home_provider.dart';
// import '../../../../components/poviders/location_provider/location_provider.dart';
// import '../../../../components/router/router.dart';
// import '../../../../components/styles/size_config.dart';
// import '../../../../components/utils/dialogs.dart';
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
//   SharedPrefs sharedPrefs = SharedPrefs();
//   @override
//   void initState() {
//     super.initState();
//     // syncOfflineData();
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
//     final isConnected = await _networkService.isConnected();

//     try {
//       // Get current position (common for both online and offline)
//       locationPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 10),
//       ).timeout(const Duration(seconds: 10), onTimeout: () {
//         throw TimeoutException("Location retrieval timed out");
//       });

//       if (!mounted) return;

//       logger.i(
//           "User location: ${locationPosition.latitude}, ${locationPosition.longitude}");

//       // Define target coordinates and radius based on connection status
//       double? targetLatitude;
//       double? targetLongitude;
//       double? allowedDistance;

//       if (isConnected) {
//         // Online mode - Get coordinates from API
//         final locationProvider =
//             ref.read(stateLocationProvider).getConditionSettingModel;
//         if (locationProvider?.data == null) {
//           logger.e("Invalid location data from provider");
//           return;
//         }

//         final data = locationProvider!.data!;
//         targetLatitude = data.officeLat;
//         targetLongitude = data.officeLong;
//         allowedDistance = data.radius;
//       } else {
//         // Offline mode - Use hardcoded coordinates
//         targetLatitude = 17.9702451;
//         targetLongitude = 102.6233528;
//         allowedDistance = 333.33;
//       }

//       // Validate coordinates
//       if (targetLatitude == null ||
//           targetLongitude == null ||
//           allowedDistance == null) {
//         logger.e(
//             "Missing location parameters: lat=$targetLatitude, long=$targetLongitude, radius=$allowedDistance");
//         return;
//       }

//       // Calculate distance and validate location (common logic)
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

//       // Common data preparation

//       if (isConnected) {
//         // Online mode - API call
//         try {
//           final response = await EnterpriseAPIService().saveAttendanceData(
//             type: keyword,
//             userID: userId,
//             latitude: locationPosition.latitude,
//             longitude: locationPosition.longitude,
//             imagePath: '',
//             title: '',
//           );

//           if (response['status'] != true) {
//             logger.e("Attendance save failed: ${response['message']}");
//             // Save to SQLite as fallback
//             await _saveToSQLite(
//                 userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//                 type: keyword,
//                 latitude: locationPosition.latitude,
//                 longitude: locationPosition.longitude,
//                 imagePath: imagePath,
//                 title: '');
//             return;
//           }

//           final data = response['data'];
//           if (data == null) {
//             logger.e("No data returned from attendance API");
//             return;
//           }

//           final clockInTime = data['date'] as String? ?? '';
//           final typeClock = data['type_clock'] as String? ?? '';
//           final isLate = data['status_late'] as bool? ?? false;

//           // ignore: use_build_context_synchronously
//           context.push(
//             PageName.attendanceSuccess,
//             extra: {
//               'clockInTime': clockInTime,
//               'typeClock': typeClock,
//               'isLate': isLate,
//             },
//           );

//           logger.d("Attendance response: $response");

//           final homeNotifier = ref.read(stateHomeProvider.notifier);
//           typeClock == 'IN'
//               ? homeNotifier.setClockInTrue()
//               : homeNotifier.setClockInFalse();
//           // await syncOfflineData();
//         } on DioException catch (e) {
//           if (context.mounted) {
//             await _saveToSQLite(
//               userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//               type: keyword,
//               latitude: locationPosition.latitude,
//               longitude: locationPosition.longitude,
//               imagePath: '',
//               title: '',
//             ).whenComplete(() => alertSuccessDialog(context));
//           }
//         } catch (e) {
//           if (context.mounted) {
//             await _saveToSQLite(
//               userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//               type: keyword,
//               latitude: locationPosition.latitude,
//               longitude: locationPosition.longitude,
//               imagePath: '',
//               title: '',
//             ).whenComplete(() => alertSuccessDialog(context));
//             // ignore: use_build_context_synchronously
//             // errorDialog(context: context, onError: e);
//           }
//         }
//       } else {
//         // Offline mode - Save to SQLite
//         await _saveToSQLite(
//                 userId: sharedPrefs.getStringNow(KeyShared.keyUserId),
//                 type: keyword,
//                 latitude: locationPosition.latitude,
//                 longitude: locationPosition.longitude,
//                 imagePath: '',
//                 title: '')
//             // ignore: use_build_context_synchronously
//             .whenComplete(() => alertSuccessDialog(context));
//       }
//     }

// // Helper method to save to SQLite
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

//   Future<void> alertSuccessDialog(
//     BuildContext context,
//   ) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertSuccessDialog(
//             title: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.7,
//               height: MediaQuery.of(context).size.width * 0.3,
//               child: Lottie.asset(
//                 ImagePath.imgSuccessfully,
//                 width: SizeConfig.widthMultiplier * 6,
//                 height: SizeConfig.heightMultiplier * 6,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   Strings.txtSuccessFully.tr,
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   Strings.txtClockOffline.tr,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
//                 ),
//                 Text(
//                   Strings.txtClockOfflineSet.tr,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
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
//       height: SizeConfig.heightMultiplier * 22,
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
//             Expanded(
//               child: SlideCheck(
//                   clockIn: ref.watch(stateHomeProvider).isClockedIn,
//                   callback: () async {
//                    final isValidLocation =
//                         ref.watch(stateHomeProvider).isValidLocation;
//                         logger.d('123${isValidLocation}');
//                     final hasPermission =
//                         await _requestLocationPermission(context);
//                     if (hasPermission) {
//                       if (isValidLocation) {
//                         await clockInOutService();
//                       } else {
//                         context.push(PageName.attendanceScreens);
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Location permission is required.')),
//                       );
//                     }
//                   }),
//             ).animate().scaleXY(
//                 begin: 0,
//                 end: 1,
//                 delay: 500.ms,
//                 duration: 500.ms,
//                 curve: Curves.easeInOutCubic),
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