// import 'package:enterprise/components/models/user_model/user_model.dart';
// import 'package:enterprise/components/services/api_service/enterprise_service.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mockito/mockito.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// class MockUserProvider extends Mock implements UserModel {}

// void main() {
//   late Geolocator mockGeolocator;
//   late EnterpriseAPIService mockApiService;
//   late SharedPreferences mockSharedPrefs;
//    late ImagePicker mockImagePicker;
//   // late MockStateHomeProvider mockHomeProvider;
//   late MockUserProvider mockUserProvider;
//   setUp(() {
//     mockGeolocator = Geolocator();
//     mockApiService = EnterpriseAPIService();
//           mockUserProvider = MockUserProvider();
//     // mockSharedPrefs = SharedPreferences();
//   });
  
//   // testWidgets('BoxCheckWidgets initializes and requests location',
//   //     (WidgetTester tester) async {
//   //   when(mockGeolocator.getCurrentPosition(
//   //           desiredAccuracy: LocationAccuracy.high))
//   //       .thenAnswer((_) async => Position(
//   //             latitude: 37.7749,
//   //             longitude: -122.4194,
//   //             timestamp: DateTime.now(),
//   //             accuracy: 1.0,
//   //             altitude: 0.0,
//   //             heading: 0.0,
//   //             speed: 0.0,
//   //             speedAccuracy: 0.0,
//   //           ));

//   //   await tester.pumpWidget(
//   //     ProviderScope(
//   //       child: MaterialApp(
//   //         home: BoxCheckWidgets(sharedPrefs: mockSharedPrefs),
//   //       ),
//   //     ),
//   //   );

//   //   await tester.pumpAndSettle();

//   //   verify(mockGeolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high))
//   //       .called(1);
//   // });

//   test('Valid location check should return true within range', () {
//     final latitude = 37.7749;
//     final longitude = -122.4194;
//     final officeLat = 37.7749;
//     final officeLong = -122.4194;
//     final radius = 50.0; // 50 meters

//     final distance = Geolocator.distanceBetween(
//       latitude,
//       longitude,
//       officeLat,
//       officeLong,
//     );

//     expect(distance <= radius, isTrue);
//   });

//   test('Invalid location check should return false outside range', () {
//     final latitude = 37.7749;
//     final longitude = -122.4194;
//     final officeLat = 37.7749;
//     final officeLong = -122.4294;
//     final radius = 50.0;

//     final distance = Geolocator.distanceBetween(
//       latitude,
      
//       longitude,
//       officeLat,
//       officeLong,
//     );

//     expect(distance <= radius, isFalse);
//   });

//   test('Clock-in API call success', () async {
//     when(mockApiService.saveAttendanceData(
//       type: 'OFFICE',
//       userID: 1234,
//       latitude: 37.7749,
//       longitude: -122.4194,
//       imagePath: '',
//       title: '',
//     )).thenAnswer((_) async => {
//           'status': true,
//           'data': {'type_clock': 'IN'}
//         });

//     final response = await mockApiService.saveAttendanceData(
//       type: 'OFFICE',
//       userID: 1234,
//       latitude: 37.7749,
//       longitude: -122.4194,
//       imagePath: '',
//       title: '',
//     );

//     expect(response['status'], true);
//     // expect(response['data']['type_clock'], 'IN');
//   });

//   test('Clock-in API call failure', () async {
//     when(mockApiService.saveAttendanceData(
//       type: 'OFFICE',
//       userID: 1234,
//       latitude: 37.7749,
//       longitude: -122.4194,
//       imagePath: '',
//       title: '',
//     )).thenAnswer((_) async => {'status': false, 'message': 'Error'});

//     final response = await mockApiService.saveAttendanceData(
//       type: 'OFFICE',
//       userID: 1234,
//       latitude: 37.7749,
//       longitude: -122.4194,
//       imagePath: '',
//       title: '',
//     );

//     expect(response['status'], false);
//     expect(response['message'], 'Error');
//   });
// }
