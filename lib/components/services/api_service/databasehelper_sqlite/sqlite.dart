// import 'dart:math';

// import 'package:dio/dio.dart';
// import 'package:enterprise/components/constants/image_path.dart';
// import 'package:enterprise/components/constants/strings.dart';
// import 'package:enterprise/components/logger/logger.dart';
// import 'package:enterprise/components/models/attendance_sqlite_model/sqlite_model.dart';
// import 'package:enterprise/components/services/api_service/enterprise_service.dart';
// import 'package:enterprise/components/styles/size_config.dart';
// import 'package:enterprise/components/utils/dialogs.dart';
// import 'package:enterprise/components/utils/dio_exceptions.dart';
// import 'package:enterprise/views/widgets/app_dialog/alerts_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lottie/lottie.dart';

// class Sqlite extends StatefulWidget {
//   const Sqlite({Key? key}) : super(key: key);

//   @override
//   _SqliteState createState() => _SqliteState();
// }

// class _SqliteState extends State<Sqlite> {
//   late Future<List<SQLiteModel>> _attendanceFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadAttendanceData();
//   }

//   // Load attendance data from SQLite
//   void _loadAttendanceData() {
//     setState(() {
//       _attendanceFuture = DatabaseHelper.instance.getattendance();
//     });
//   }

//   // Delete attendance record
//   Future<void> _deleteAttendance(int id) async {
//     try {
//       await DatabaseHelper.instance.deleteattend(id);
//       _loadAttendanceData(); // Refresh the list after deletion
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Attendance record deleted successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error deleting record: $e')),
//       );
//     }
//   }
// Future<void> _syncAttendanceData() async {
//   try {
//     List<SQLiteModel> unsyncedRecords =
//         await DatabaseHelper.instance.getUnsyncedAttendance();

//     for (var record in unsyncedRecords) {
//       print("Syncing ID: ${record.id}");

//       try {
//         final response = await EnterpriseAPIService().saveAttendanceData(
//           type: record.type!,
//           userID: record.idUser!,
//           latitude: record.latitude!,
//           longitude: record.longitude!,
//           imagePath: record.imagePath ?? '',
//           title: record.title ?? '',
//           createdAt: record.createdAt ??''
//         );

//         logger.d("Response type: ${response.runtimeType}");
//         logger.d("Response content: $response");

//         if (response['status'] == 200) {
//           await DatabaseHelper.instance.deleteattend(record.id!);
//         } else {
//           errorDialog(context: context, onError: response['error'] ?? '');
//         }
//       } on DioException catch (e) {
//         logger.e("Network error during sync: ${DioExceptions.fromDioError(e)}");
//         if (context.mounted) errorDialog(context: context, onError: e.toString());
//       } catch (e) {
//         logger.e("Unexpected error during sync: $e");
//         if (context.mounted) errorDialog(context: context, onError: e.toString());
//       }
//     }

//     await Future.delayed(Duration(milliseconds: 100));
//     _loadAttendanceData();


//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Data synced and deleted successfully')),
//     );
//   } catch (e) {
//     logger.e('error:${e}');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error syncing data: $e')),
//     );
//   }
// }
 
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
//       height: 400,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<List<SQLiteModel>>(
//               future: _attendanceFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                       child: Text("No attendance records found"));
//                 }

//                 final attendanceList = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: attendanceList.length,
//                   itemBuilder: (context, index) {
//                     final attendance = attendanceList[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 8.0,
//                         vertical: 4.0,
//                       ),
//                       child: ListTile(
//                         title: Text("Type: ${attendance.type}"),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("User ID: ${attendance.idUser}"),
//                             Text(
//                                 "Lat: ${attendance.latitude}, Long: ${attendance.longitude}"),
//                             Text("Date: ${attendance.createdAt}"),
//                             Text(
//                                 "Synced: ${attendance.isSynced ? 'Yes' : 'No'}"),
//                             if (attendance.imagePath != null &&
//                                 attendance.imagePath!.isNotEmpty)
//                               Text("Image: ${attendance.imagePath}"),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               attendance.isSynced
//                                   ? Icons.cloud_done
//                                   : Icons.cloud_off,
//                               color: attendance.isSynced
//                                   ? Colors.green
//                                   : Colors.grey,
//                             ),
//                             const SizedBox(width: 8),
//                             IconButton(
//                               icon: const Icon(Icons.sync, color: Colors.blue),
//                               onPressed: () async {
//                                 final confirm = await showDialog<bool>(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: const Text('Confirm Sync'),
//                                     content: const Text(
//                                         'Are you sure you want to sync this attendance record?'),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () =>
//                                             Navigator.pop(context, false),
//                                         child: const Text('Cancel'),
//                                       ),
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.pop(context, true);
//                                         },
//                                         child: const Text('Sync'),
//                                       ),
//                                     ],
//                                   ),
//                                 );

//                                 if (confirm == true) {
//                                   await _syncAttendanceData();
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           // Refresh button
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: _loadAttendanceData,
//                   child: const Text("Refresh"),
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       _syncAttendanceData();
//                     },
//                     child: Text('Aync'))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
