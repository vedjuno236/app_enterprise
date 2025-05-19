import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/poviders/attendance_provider/attendance_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_login.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widgets_easier/widgets_easier.dart';
import '../../../components/constants/colors.dart';
import '../../../components/constants/key_shared.dart';
import '../../../components/constants/strings.dart';
import '../../../components/logger/logger.dart';
import '../../../components/poviders/home_provider/home_provider.dart';
import '../../../components/poviders/location_provider/location_provider.dart';
import '../../../components/poviders/users_provider/users_provider.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/styles/size_config.dart';
import '../../../components/utils/dialogs.dart';
import '../../widgets/bottom_sheet_push/bottom_sheet_push.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum AppState {
  free,
  picked,
}

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  XFile? _imageFile;

  final Completer<GoogleMapController> _controller = Completer();
  double? _latitude = 17.970433;
  double? _longitude = 102.6234143;
  // static const LatLng sourceLocation = LatLng(17.9702055, 102.6208356);
  static const String keyApiGoogleMap =
      "AIzaSyD0HpQe3U7tDlOpS1vrjhFnob0xmmQJQDo";
  Position? _currentPosition;
  GoogleMapController? _googleMapController;

  List<LatLng> polylineCoordinates = [];
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor officeIcon = BitmapDescriptor.defaultMarker;

  // void getPolyPoints() async {
  //   try {
  //     PolylinePoints polylinePoints = PolylinePoints();
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       request: PolylineRequest(
  //         origin:
  //             PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //         destination: PointLatLng(
  //             _currentPosition!.latitude, _currentPosition!.longitude),
  //         mode: TravelMode.driving,
  //       ),
  //       googleApiKey: keyApiGoogleMap,
  //     );

  //     if (result.points.isNotEmpty) {
  //       polylineCoordinates.clear();
  //       for (var point in result.points) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //       setState(() {});
  //     } else {
  //       print("Failed to get polyline points: ${result.errorMessage}");
  //     }
  //   } catch (e) {
  //     print("Error getting polyline: $e");
  //   }
  // }

  Future<Position?> findCurrentLocation() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e);
    }
    return position;
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _getCurrentLocationInternal();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  void moveCameraToCurrentPosition() {
    _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_latitude!, _longitude!),
            zoom: 20.0,
            bearing: 45.0,
            tilt: 10.0),
      ),
    );
  }

  Future<Position?> getLocatePosition() async {
    Position? position = await findCurrentLocation();
    _latitude = position!.latitude;
    _longitude = position.longitude;
    setState(() {});
    print('_latitude$_latitude');
    print('_longitude$_longitude');
  }

  Future<Position> _getCurrentLocationInternal() async {
    bool serviceEnabled;
    LocationPermission permission;
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  bool isLoading = false;

  TextEditingController description = TextEditingController();

  SharedPrefs sharedPrefs = SharedPrefs();

  bool isLoadinUser = false;
  bool isLoadinLocation = false;
  Future fetchUserApi() async {
    setState(() {
      isLoadinUser = true;
    });

    EnterpriseAPIService()
        .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken))
        .then((value) {
      ref.watch(stateUserProvider).setUserModel(value: value);
    }).catchError((onError) {
      errorDialog(onError: onError, context: context);
    }).whenComplete(() {
      setState(() {
        isLoadinUser = true;
      });
    });
  }

  Future<void> _callLocationApi() async {
    setState(() {
      isLoadinLocation = true;
    });
    EnterpriseAPIService().callLocationAPI().then((value) {
      ref.watch(stateLocationProvider).setLocationModels(value: value);
      // logger.d(value);
    }).catchError((onErorr) {
      errorDialog(onError: onErorr, context: context);
    }).whenComplete(() {
      setState(() {
        isLoadinLocation = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentMapType = MapType.normal;
    _getCurrentLocation();
  }

  MapType? currentMapType;

  @override
  void dispose() {
    description.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  // final NetworkService _networkService = NetworkService();
  Future<void> clockInOutService() async {
    final attendanceProvider = ref.watch(stateAttendanceProvider);
    final userProvider = ref.watch(stateUserProvider);

 
    try {
      attendanceProvider.isLoading = true;
      final response = await EnterpriseAPIService().saveAttendanceData(
        type: "REMOTE",
        userID: userProvider.getUserModel!.data!.id ?? 0,
        longitude: _currentPosition!.latitude,
        latitude: _currentPosition!.longitude,
        imagePath: _imageFile!.path,
        title: description.text,
        createdAt: DateTime.now().toIso8601String(),
      );
      if (response != null) {
        var data = response['data'];
        String clockInTime = data?['date'] ?? '';
        String typeClock = data?['type_clock'] ?? '';
        bool isLate = data?['status_late'] ?? false;

        context.pushReplacement(
          PageName.attendanceSuccess,
          extra: {
            'clockInTime': clockInTime,
            'typeClock': typeClock,
            'isLate': isLate,
          },
        );
        if (response['data']['type_clock'] == 'IN') {
          ref.watch(stateHomeProvider.notifier).setClockInTrue();
        } else {
          ref.watch(stateHomeProvider.notifier).setClockInFalse();
        }
      } else {
        logger.e("Clock-in failed: Response is null.");
      }
    } on DioException catch (e) {
      if (context.mounted) {
        
        errorDialog(context: context, onError: e);
      }
      attendanceProvider.isLoading = false;
    } catch (e) {
      if (context.mounted) {
     
        errorDialog(context: context, onError: e);
      }
    }
   
  }

  AppState state = AppState.free;

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = ref.watch(stateAttendanceProvider);
    final locProvider = ref.watch(stateLocationProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            top: SizeConfig.heightMultiplier * 25,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: kYellowColor,
                    onPressed: () {
                      setState(() {
                        currentMapType = MapType.hybrid;
                      });
                    },
                    child: const Icon(
                      Icons.map,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                CircleAvatar(
                  radius: 20,
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    backgroundColor: Colors.orange,
                    onPressed: () {
                      setState(() {
                        currentMapType = MapType.normal;
                      });
                    },
                    child: const Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                CircleAvatar(
                  radius: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      getLocatePosition();
                      moveCameraToCurrentPosition();
                    },
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: CustomProgressHUD(
        key: UniqueKey(),
        inAsyncCall: attendanceProvider.isLoading,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            color: Theme.of(context).canvasColor,
            width: double.infinity,
            height: SizeConfig.heightMultiplier * 100,
            child: Column(
              children: [
                Expanded(
                  child: _currentPosition == null
                      ? AppShimmer(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: kTextWhiteColor,
                          ),
                        )
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude),
                            zoom: 16.5,
                          ),
                          mapType: currentMapType!,
                          markers: {
                            Marker(
                                markerId: const MarkerId('Yes'),
                                position: LatLng(_latitude!.toDouble(),
                                    _longitude!.toDouble())),
                            Marker(
                              icon: sourceIcon,
                              markerId: const MarkerId('NO'),
                              position: LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude),
                            ),
                          },
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text.rich(
                              TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                text: Strings.txtYouAre.tr,
                                children: [
                                  TextSpan(
                                    text: Strings.txtNot.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: kRedColor,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: Strings.txtClockInArea.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .slideY(
                                    duration: 900.ms,
                                    curve: Curves.easeOutCubic)
                                .fadeIn(),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            Text(
                              Strings.txtThisLoaction.tr,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.9),
                            )
                                .animate()
                                .slideY(
                                    duration: 900.ms,
                                    curve: Curves.easeOutCubic)
                                .fadeIn(),
                            const Divider(
                              color: Color(0xFFF3F3F3),
                              thickness: 1.0,
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.txtPleaseEnterLocation.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.9,
                                          ),
                                    )
                                        .animate()
                                        .slideY(
                                            duration: 900.ms,
                                            curve: Curves.easeOutCubic)
                                        .fadeIn(),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(120)
                                      ],
                                      maxLines: 1,
                                      controller: description,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Theme.of(context).canvasColor,
                                        focusColor: kGary,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: kGary, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: kGary, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: kGary, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        hintText: Strings.txtEX.tr,
                                        hintStyle:
                                            const TextStyle(color: kTextGrey),
                                        prefixIcon:
                                            Image.asset(ImagePath.iconLocation),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    )
                                        .animate()
                                        .slideY(
                                            duration: 900.ms,
                                            curve: Curves.easeOutCubic)
                                        .fadeIn(),
                                    SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 1),
                                    Text(
                                      Strings.txtPoto.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(),
                                    )
                                        .animate()
                                        .slideY(
                                            duration: 900.ms,
                                            curve: Curves.easeOutCubic)
                                        .fadeIn(),
                                    SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 1),
                                    GestureDetector(
                                      onTap: () async {
                                        bottomSheetPushContainer(
                                          context: context,
                                          constantsSize: 1,
                                          child: buttonChooseImage(context),
                                        );
                                      },
                                      child: Container(
                                        height: _imageFile == null
                                            ? SizeConfig.heightMultiplier * 25
                                            : null,
                                        width: SizeConfig.widthMultiplier * 100,
                                        decoration: ShapeDecoration(
                                          color: Theme.of(context).canvasColor,
                                          shape: DashedBorder(
                                            color: Color(0xFFE2E6EA),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: _imageFile == null
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      Strings.txtUploadImage.tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  1.9),
                                                    ),
                                                    SizedBox(
                                                        height: SizeConfig
                                                                .heightMultiplier *
                                                            2),
                                                    SizedBox(
                                                      child: Image.asset(
                                                        ImagePath.iconIconImage,
                                                        width: SizeConfig
                                                                .widthMultiplier *
                                                            6,
                                                        height: SizeConfig
                                                                .heightMultiplier *
                                                            6,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            13.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image(
                                                        image: FileImage(
                                                          File(
                                                              _imageFile!.path),
                                                        ),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 5,
                                                    right: 5,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _imageFile = null;
                                                          state = AppState
                                                              .picked; // Assuming AppState.initial is the default state
                                                        });
                                                      },
                                                      child: const CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            kRedColor,
                                                        child: Icon(
                                                          Icons.close,
                                                          color:
                                                              kTextWhiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      )
                                          .animate()
                                          .slideY(
                                              duration: 900.ms,
                                              curve: Curves.easeOutCubic)
                                          .fadeIn(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IntrinsicWidth(
              child: SizedBox(
                height: SizeConfig.heightMultiplier * 5,
                width: SizeConfig.widthMultiplier * 35,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: kRedColor),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: kPinkLigthColor,
                  ),
                  child: Text(
                    Strings.txtCancel.tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: SizeConfig.textMultiplier * 1.9,
                        color: kRedColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            IntrinsicWidth(
              child: SizedBox(
                height: SizeConfig.heightMultiplier * 5,
                width: SizeConfig.widthMultiplier * 35,
                child: ElevatedButton(
                  onPressed: attendanceProvider.isLoading
                      ? null
                      : () async {
                          if (!attendanceProvider.isLoading) {
                      
                              attendanceProvider.isLoading = true;
                            
                          }

                          try {
                            if (_formKey.currentState!.validate()) {
                              if (_imageFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(Strings.txtPleaseUpload),
                                  ),
                                );
                                return;
                              }

                              await clockInOutService();
                            }
                          } finally {
                     
                              attendanceProvider.isLoading = false;
                            
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: kYellowFirstColor,
                  ),
                  child: attendanceProvider.isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Strings.txtLoading.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: kBack,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          Strings.txtClockIn.tr,
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.8,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget buttonChooseImage(context) {
    return Container(
      color: Theme.of(context).canvasColor,
      height: SizeConfig.heightMultiplier * 9,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            Strings.txtPleaseChooseImage.tr,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () async {
                  _takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.camera_alt_outlined, color: kYellowColor),
                label: Text(
                  Strings.txtCamera.tr,
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  _takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image_outlined, color: kYellowColor),
                label: Text(
                  Strings.txtGallery.tr,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _takePhoto(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
        state = AppState.picked;
      });
    }
  }
}
