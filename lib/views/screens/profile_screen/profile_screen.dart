import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/languages/localization_service.dart';
import 'package:enterprise/components/models/user_model/user_model.dart';
import 'package:enterprise/components/poviders/bottom_bar_provider/bottom_bar_provider.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/screens/auth/translate.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../components/constants/key_shared.dart';
import '../../../components/constants/strings.dart';
import '../../../components/helpers/shared_prefs.dart';
import '../../../components/logger/logger.dart';
import '../../../components/mock/mock.dart';
import '../../../components/poviders/users_provider/users_provider.dart';
import '../../../components/services/api_service/enterprise_service.dart';
import '../../../components/utils/date_format_utils.dart';
import '../../../components/utils/dialogs.dart';
import '../../widgets/bottom_sheet_push/bottom_sheet_push.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  SharedPrefs sharedPrefs = SharedPrefs();
  int userID = int.parse(SharedPrefs().getStringNow(KeyShared.keyUserId));

  bool isLoadingUser = false;
  Future fetchUserApi() async {
    setState(() {
      isLoadingUser = true;
    });
    EnterpriseAPIService()
        .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken))
        .then((value) {
      ref.watch(stateUserProvider).setUserModel(value: value);
      logger.d(value);
    }).catchError((onError) {
      errorDialog(
        context: context,
        onError: onError,
      );
      logger.e(DioExceptions.fromDioError(onError));
    }).whenComplete(() => setState(() {
              isLoadingUser = false;
            }));
  }

  Future<void> _loadSavedLanguage() async {
    final saveLocale = await LocalizationService.getSaveLocal();
    setState(() {});
  }

  void checkToken() async {
    final token = sharedPrefs.getStringNow(KeyShared.keyToken);
    if (token != null && token.isNotEmpty) {
      context.go(PageName.navigatorBarScreenRoute);
    } else {
      context.go(PageName.login);
    }
  }

  Future<void> checkExpiredToken() async {
    EnterpriseAPIService()
        .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken))
        .then((value) {
      ref.watch(stateUserProvider).setUserModel(value: value);
      // ignore: use_build_context_synchronously
      context.go(PageName.navigatorBarScreenRoute);
    }).catchError((onError) {
      String errorMessage = DioExceptions.fromDioError(onError).toString();

      if (errorMessage == "Unauthorized") {
        context.go(PageName.login);
      }
    });
  }
  Future<void> updateProfile(File croppedFile) async {
    setState(() => isLoadingInfo = true);
    try {
      final value = await EnterpriseAPIService().profileUpdate(
        File(croppedFile.path),
        userId: userID,
      );
      final userInfo = await EnterpriseAPIService()
          .callUserInfos(token: sharedPrefs.getStringNow(KeyShared.keyToken));
      ref.read(stateUserProvider.notifier).setUserModel(value: userInfo);
      Fluttertoast.showToast(
        msg: 'ສໍາເລັດຮູບພາບສໍາເລັດ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (onError) {
      if (onError.runtimeType.toString() == 'DioError') {
        errorDialog(context: context, onError: onError);
      }
    } finally {
      setState(() => isLoadingInfo = false);
    }
  }

  bool isConnectedInternet = false;
  StreamSubscription? _streamSubscription;

  AppState state = AppState.free;

  @override
  void initState() {
    super.initState();
    checkExpiredToken();
    fetchUserApi();
    _loadSavedLanguage();
  }

  // final _picker = ImagePicker();
  XFile? _imageFile;
  XFile? _imageFileBackground;
  CroppedFile? _croppedFile;
  CroppedFile? _croppedFileBackground;

  bool isLoadingInfo = false;
  @override
  void dispose() {
    _streamSubscription?.cancel();
    _imageFile;
    _imageFileBackground;
    super.dispose();
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: _imageFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'ແປງຂະໜາດຮູບພາບ',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
              ],
            ),
            IOSUiSettings(
              title: 'ແປງຂະໜາດຮູບພາບ',
              aspectRatioPresets: [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio4x3,
              ],
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _croppedFile = croppedFile;
          });
          final file = File(croppedFile.path);
          updateProfile(file);
        } else {
          setState(() {
            _croppedFile = null;
          });
        }
      } catch (e) {
        print('Error cropping image: $e');
      }
    }
  }

  Future _cropImageBackground() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFileBackground!.path,
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Background',
          toolbarColor: kPrimaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Crop Background',
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFileBackground = croppedFile;
      });
    }
  }

  Future<void> _takePhotoBackground(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFileBackground = pickedImage;
        state = AppState.picked;
      });

      await _cropImageBackground();
    }
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

      await _cropImage();
    }
  }

  Widget _buildLoadingNull() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kTextWhiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppShimmer(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      height: SizeConfig.heightMultiplier * 30,
                      color: kGary,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 120,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: const AppShimmer(
              child: CircleAvatar(
                radius: 100,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(stateUserProvider);
    final userData = userProvider.getUserModel?.data;
    final darkTheme = ref.watch(darkThemeProviderProvider);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Builder(builder: (context) {
          final user = userProvider.getUserModel;

          if (user == null) {
            return Center(
              child: _buildLoadingNull(),
            );
          }

          if (user!.data == null) {
            return _buildLoadingNull();
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  widgetBackground(context),
                  Container(
                    margin: const EdgeInsets.only(top: 75),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 35, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userData!.firstName.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 3,
                                            color: Color(0xFF19295C)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userData!.lastName.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 3,
                                            color: Color(0xFF19295C)),
                                  )
                                      .animate()
                                      .slideY(
                                          duration: 900.ms,
                                          curve: Curves.easeOutCubic)
                                      .fadeIn(),
                                  SizedBox(
                                      width: SizeConfig.widthMultiplier * 1),
                                  const CircleAvatar(
                                    radius: 8,
                                    backgroundColor: kBlueColor,
                                    child: Icon(
                                      Icons.check,
                                      color: kTextWhiteColor,
                                      size: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 1),
                              Text(
                                userData!.positionName.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        fontSize: SizeConfig.textMultiplier * 2,
                                        color: Color(0xFF99A1BE)),
                              )
                                  .animate()
                                  .slideY(
                                      duration: 900.ms,
                                      curve: Curves.easeOutCubic)
                                  .fadeIn(),
                              SizedBox(height: SizeConfig.heightMultiplier * 1),
                              InkWell(
                                  onTap: () {
                                    context.push(PageName.editProfileRoute);
                                  },
                                  child: Container(
                                    height: SizeConfig.heightMultiplier * 5,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBD346),
                                      // color: submitButtonColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.edit),
                                        SizedBox(
                                            width:
                                                SizeConfig.widthMultiplier * 1),
                                        Text(
                                          Strings.txtEditProfile.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      2),
                                        ),
                                      ],
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 500.ms)
                                      .shimmer(
                                          blendMode: BlendMode.srcOver,
                                          color: kGary)
                                      .move(
                                          begin: Offset(-16, 0),
                                          curve: Curves.easeOutQuad)),
                              SizedBox(height: SizeConfig.heightMultiplier * 1),
                              GestureDetector(
                                  onTap: () {
                                    context.push(PageName.rankingRoute);
                                  },
                                  child: Container(
                                    height: SizeConfig.heightMultiplier * 10,
                                    decoration: BoxDecoration(
                                      color: kTextWhiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: rankingData.map((rank) {
                                          Widget image;

                                          String labelText;

                                          if (rank['type'] == 'diamonds') {
                                            image = Image.asset(
                                                ImagePath.iconDiamonds);

                                            labelText = 'Your Diamonds';
                                          } else {
                                            image = Image.asset(
                                                ImagePath.iconLeave);

                                            labelText = 'Your Hearts';
                                          }

                                          return Row(
                                            children: [
                                              CircleAvatar(
                                                radius: SizeConfig
                                                        .heightMultiplier *
                                                    2.5,
                                                backgroundColor:
                                                    kGary.withOpacity(0.5),
                                                child: image,
                                              ),
                                              SizedBox(
                                                  width: SizeConfig
                                                          .widthMultiplier *
                                                      1),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    labelText,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Text(
                                                    rank['number'],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontSize: SizeConfig
                                                                    .textMultiplier *
                                                                1.7),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(duration: 500.ms, delay: 500.ms)
                                      .shimmer(
                                          blendMode: BlendMode.srcOver,
                                          color: kGary)
                                      .move(
                                          begin: Offset(-16, 0),
                                          curve: Curves.easeOutQuad)),
                            ],
                          ),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          Text(
                            Strings.txtAboutMe,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.8),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kTextWhiteColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Respects and positive energyRespects\nCodeing',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.8,
                                        color: kBack.withOpacity(0.8)),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          Text(
                            Strings.txtInformation,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          // widgetInformation(context, userData)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kTextWhiteColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(ImagePath.iconWork),
                                      SizedBox(
                                        width: SizeConfig.widthMultiplier * 2,
                                      ),
                                      Text(
                                        'NCC',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.8,
                                                color: kBack.withOpacity(0.8)),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.heightMultiplier * 1),
                                  Row(
                                    children: [
                                      Image.asset(ImagePath.iconLives),
                                      SizedBox(
                                        width: SizeConfig.widthMultiplier * 2,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.9,
                                                  color:
                                                      kBack.withOpacity(0.8)),
                                          text: 'Lives In ',
                                          children: [
                                            TextSpan(
                                              text: userData.village.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.9,
                                                      color: kText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.heightMultiplier * 1),
                                  Row(
                                    children: [
                                      Image.asset(ImagePath.iconDepart),
                                      SizedBox(
                                        width: SizeConfig.widthMultiplier * 2,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.9,
                                                  color:
                                                      kBack.withOpacity(0.8)),
                                          text: 'Department ',
                                          children: [
                                            TextSpan(
                                              text: userData.departmentName
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.9,
                                                      color: kText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.heightMultiplier * 1),
                                  Row(
                                    children: [
                                      Image.asset(ImagePath.iconStart),
                                      SizedBox(
                                        width: SizeConfig.widthMultiplier * 2,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      1.9,
                                                  color:
                                                      kBack.withOpacity(0.8)),
                                          text: 'Sart working ',
                                          children: [
                                            TextSpan(
                                              text: DateFormatUtil.formatA(
                                                  DateTime.parse(
                                                      userData.workStartDate!)),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          1.9,
                                                      color: kText,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 500.ms, delay: 500.ms)
                              .move(
                                  begin: Offset(-16, 0),
                                  curve: Curves.easeOutQuad),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Award(5)",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontSize:
                                                SizeConfig.textMultiplier * 2),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildShowAwardModalBottomSheet(context);
                                    },
                                    child: Text(
                                      "See all",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 1),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: SizeConfig.heightMultiplier *
                                          15, // Adjust size as needed
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: wardData.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  wardData[index]['icons']
                                                      .toString(),
                                                  width: 90,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(height: 8),
                                                Expanded(
                                                  child: Text(
                                                      wardData[index]['name']
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: kText)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Passion & Skills",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: skillsData.map((skill) {
                              return Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: kTextWhiteColor,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: kYellowFirstColor,
                                    width: 1.0,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                        width: SizeConfig.widthMultiplier * 1),
                                    Row(
                                      children: [
                                        Text(
                                          skill['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: txt),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const LanguageSwitcher(),
                      Switch.adaptive(
                        value: darkTheme.darkTheme,
                        onChanged: (value) {
                          darkTheme.darkTheme = value;
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          ref
                              .read(stateBottomBarProvider.notifier)
                              .resetState();

                          if (sharedPrefs.getStringNow(KeyShared.keyToken) !=
                              null) {
                            sharedPrefs.remove(KeyShared.keyToken);
                            sharedPrefs.remove(KeyShared.keyUserId);
                            sharedPrefs.remove(KeyShared.keyRole);

                            context.go(PageName.login);
                            logger
                                .d(sharedPrefs.getBoolNow(KeyShared.keyToken));
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: kTextWhiteColor,
                          side: const BorderSide(color: kTextWhiteColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/log_out.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              Strings.txtLogout,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: kRedColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: 120,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: kTextWhiteColor,
                    radius: 81,
                    child: _imageFile != null && _croppedFile != null
                        ? Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundImage: FileImage(
                                  File(_croppedFile?.path ?? _imageFile!.path),
                                ),
                                onBackgroundImageError: (_, __) => const Icon(
                                  Icons.error,
                                  size: 30,
                                ),
                              ),
                              Positioned(
                                left: -5,
                                child: CustomPaint(
                                  size: const Size(158, 149),
                                  painter: ArcPainter(avatarRadius: 80),
                                ),
                              ),
                              Positioned(
                                bottom: 16.0,
                                right: -20,
                                child: InkWell(
                                  onTap: () {
                                    bottomSheetPushContainer(
                                      context: context,
                                      constantsSize: 1,
                                      child: buttonChooseImageProfile(context),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: kTextWhiteColor,
                                    radius: 19,
                                    child: CircleAvatar(
                                      backgroundColor: kGary,
                                      radius: 18,
                                      child: Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundColor: kTextWhiteColor,
                                radius: 74,
                                backgroundImage: CachedNetworkImageProvider(
                                    userData!.profile.toString()),
                              ).animate().scaleXY(
                                  begin: 0,
                                  end: 1,
                                  delay: 500.ms,
                                  duration: 500.ms,
                                  curve: Curves.easeInOutCubic),
                              Positioned(
                                left: -5,
                                child: CustomPaint(
                                  size: const Size(158, 149),
                                  painter: ArcPainter(avatarRadius: 80),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: -22,
                                child: InkWell(
                                  onTap: () {
                                    bottomSheetPushContainer(
                                      context: context,
                                      child: buttonChooseImageProfile(context),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: kTextWhiteColor,
                                    radius: 25,
                                    child: CircleAvatar(
                                      backgroundColor: kGary,
                                      radius: 22,
                                      child: Icon(Icons.camera_alt),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget widgetBackground(BuildContext context) {
    return Container(
      height: 205,
      width: double.infinity,
      color: kGary,
      child: _imageFileBackground != null && _croppedFileBackground != null
          ? Stack(
              children: [
                Image.file(
                  File(_croppedFileBackground?.path ??
                      _imageFileBackground!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 30,
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: InkWell(
                    onTap: () {
                      bottomSheetPushContainer(
                        context: context,
                        constantsSize: 1,
                        child: buttonChooseImageBackground(context),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: kTextWhiteColor,
                      radius: 19,
                      child: CircleAvatar(
                        backgroundColor: kGary,
                        radius: SizeConfig.heightMultiplier * 1.8,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://img.freepik.com/premium-photo/white-abstract-background-smooth_198067-217555.jpg?w=1800",
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: 30,
                  ),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: SizeConfig.heightMultiplier * 30,
                ).animate().scaleXY(
                    begin: 0,
                    end: 1,
                    delay: 500.ms,
                    duration: 500.ms,
                    curve: Curves.easeInOutCubic),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: InkWell(
                    onTap: () {
                      bottomSheetPushContainer(
                        context: context,
                        constantsSize: 1,
                        child: buttonChooseImageBackground(context),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: kTextWhiteColor,
                      radius: 19,
                      child: CircleAvatar(
                        backgroundColor: kGary,
                        radius: SizeConfig.heightMultiplier * 1.8,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ).animate().scaleXY(
                        begin: 0,
                        end: 1,
                        delay: 500.ms,
                        duration: 500.ms,
                        curve: Curves.easeInOutCubic),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buttonChooseImageBackground(context) {
    return Container(
      height: SizeConfig.heightMultiplier * 12,
      width: MediaQuery.of(context).size.width,
      // margin: const EdgeInsets.only(
      //   top: 20,
      // ),
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
                onPressed: () {
                  _takePhotoBackground(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.camera_alt_outlined, color: kYellowColor),
                label: Text(
                  Strings.txtCamera.tr,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _takePhotoBackground(ImageSource.gallery);

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

  Widget buttonChooseImageProfile(context) {
    return Container(
      height: SizeConfig.heightMultiplier * 12,
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
                onPressed: () {
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

  Future<dynamic> buildShowAwardModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Color(0xFFF8F9FC),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Award',
                          style: GoogleFonts.notoSansLao(
                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Dynamic ListView
                Expanded(
                  child: ListView.builder(
                    itemCount: wardData.length,
                    itemBuilder: (context, index) {
                      final ward = wardData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: double.infinity,
                          height: SizeConfig.heightMultiplier * 10,
                          decoration: BoxDecoration(
                            color: kTextWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: kGary,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Circle Avatar for Icon
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: SizeConfig.heightMultiplier * 3.5,
                                backgroundImage: CachedNetworkImageProvider(
                                  ward['icons'],
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Ward Name
                              Expanded(
                                child: Text(
                                  ward['name'],
                                  style: GoogleFonts.notoSansLao(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 1.8,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ArcPainter extends CustomPainter {
  final double avatarRadius;
  ArcPainter({required this.avatarRadius});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCF0D41)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: avatarRadius * 1.1,
    );

    canvas.drawArc(rect, 4.6, 3.8, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
