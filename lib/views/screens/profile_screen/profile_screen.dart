import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/screens/settings/setting_screen.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_login.dart';
import 'package:enterprise/views/widgets/shimmer/app_placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widgets_easier/widgets_easier.dart';
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
          msg: 'ແກ້ໄຂຮູບພາບສໍາເລັດ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
          fontAsset: 'NotoSansLao');
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
    darkTheme.darkTheme
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomProgressHUD(
        inAsyncCall: isLoadingInfo,
        key: UniqueKey(),
        child: SingleChildScrollView(
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
                            vertical: 35, horizontal: 16),
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
                                          ),
                                    )
                                        .animate()
                                        .slideY(
                                            duration: 900.ms,
                                            curve: Curves.easeOutCubic)
                                        .fadeIn(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(userData!.lastName.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      3,
                                                ))
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
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 1),
                                Text(
                                  userData.positionName.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.2,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                )
                                    .animate()
                                    .slideY(
                                        duration: 900.ms,
                                        curve: Curves.easeOutCubic)
                                    .fadeIn(),
                                SizedBox(
                                    height: SizeConfig.heightMultiplier * 1),
                                Divider(
                                  color: kGreyBGColor.withAlpha(80),
                                  height: 1,
                                )
                                // InkWell(
                                //     onTap: () {
                                //       context.push(PageName.editProfileRoute);
                                //     },
                                //     child: Container(
                                //       height: SizeConfig.heightMultiplier * 5,
                                //       width: double.infinity,
                                //       decoration: BoxDecoration(
                                //         color: Theme.of(context)
                                //             .colorScheme
                                //             .onPrimary,
                                //         // color: submitButtonColor,
                                //         borderRadius: BorderRadius.circular(50),
                                //       ),
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.center,
                                //         children: [
                                //           const Icon(Icons.edit),
                                //           SizedBox(
                                //               width:
                                //                   SizeConfig.widthMultiplier *
                                //                       1),
                                //           Text(
                                //             Strings.txtEditProfile.tr,
                                //             style: Theme.of(context)
                                //                 .textTheme
                                //                 .titleLarge!
                                //                 .copyWith(
                                //                     fontSize: SizeConfig
                                //                             .textMultiplier *
                                //                         2),
                                //           ),
                                //         ],
                                //       ),
                                //     )
                                //         .animate()
                                //         .fadeIn(duration: 500.ms, delay: 500.ms)
                                //         .shimmer(
                                //             blendMode: BlendMode.srcOver,
                                //             color: kGary)
                                //         .move(
                                //             begin: Offset(-16, 0),
                                //             curve: Curves.easeOutQuad)),

                                // SizedBox(
                                //     height: SizeConfig.heightMultiplier * 1),
                                // GestureDetector(
                                //     onTap: () {
                                //       context.push(PageName.rankingRoute);
                                //     },
                                //     child: Container(
                                //       height: SizeConfig.heightMultiplier * 10,
                                //       decoration: BoxDecoration(
                                //         color: Theme.of(context).canvasColor,
                                //         borderRadius: BorderRadius.circular(16),
                                //       ),
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(10.0),
                                //         child: Row(
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           children: rankingData.map((rank) {
                                //             Widget image;

                                //             String labelText;

                                //             if (rank['type'] == 'diamonds') {
                                //               image = Image.asset(
                                //                   ImagePath.iconDiamonds);

                                //               labelText = 'Your Diamonds';
                                //             } else {
                                //               image = Image.asset(
                                //                   ImagePath.iconLeave);

                                //               labelText = 'Your Hearts';
                                //             }

                                //             return Row(
                                //               children: [
                                //                 CircleAvatar(
                                //                   radius: SizeConfig
                                //                           .heightMultiplier *
                                //                       2.5,
                                //                   backgroundColor:
                                //                       kGary.withOpacity(0.5),
                                //                   child: image,
                                //                 ),
                                //                 SizedBox(
                                //                     width: SizeConfig
                                //                             .widthMultiplier *
                                //                         1),
                                //                 Column(
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.center,
                                //                   children: [
                                //                     Text(
                                //                       labelText,
                                //                       style: TextStyle(
                                //                           fontSize: 14),
                                //                     ),
                                //                     Text(
                                //                       rank['number'],
                                //                       style: Theme.of(context)
                                //                           .textTheme
                                //                           .titleLarge!
                                //                           .copyWith(
                                //                               fontSize: SizeConfig
                                //                                       .textMultiplier *
                                //                                   1.7),
                                //                     ),
                                //                   ],
                                //                 ),
                                //               ],
                                //             );
                                //           }).toList(),
                                //         ),
                                //       ),
                                //     )
                                //         .animate()
                                //         .fadeIn(duration: 500.ms, delay: 500.ms)
                                //         .shimmer(
                                //             blendMode: BlendMode.srcOver,
                                //             color: kGary)
                                //         .move(
                                //             begin: Offset(-16, 0),
                                //             curve: Curves.easeOutQuad)),
                              ],
                            ),
                            // SizedBox(height: SizeConfig.heightMultiplier * 1),
                            // Text(
                            //   Strings.txtAboutMe,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .titleLarge!
                            //       .copyWith(
                            //           fontSize:
                            //               SizeConfig.textMultiplier * 1.8),
                            // )
                            //     .animate()
                            //     .fadeIn(duration: 500.ms, delay: 500.ms)
                            //     .move(
                            //         begin: Offset(-16, 0),
                            //         curve: Curves.easeOutQuad),
                            // SizedBox(height: SizeConfig.heightMultiplier * 1),
                            // Container(
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     color: Theme.of(context).canvasColor,
                            //     borderRadius: BorderRadius.circular(16),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Text(
                            //       'Respects and positive energyRespects\nCodeing',
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .titleMedium!
                            //           .copyWith(
                            //             fontSize:
                            //                 SizeConfig.textMultiplier * 1.8,
                            //           ),
                            //       textAlign: TextAlign.left,
                            //     ),
                            //   ),
                            // )
                            //     .animate()
                            //     .fadeIn(duration: 500.ms, delay: 500.ms)
                            //     .move(
                            //         begin: Offset(-16, 0),
                            //         curve: Curves.easeOutQuad),
                            SizedBox(height: SizeConfig.heightMultiplier * 1),
                            Text(
                              Strings.txtInformation.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2.2,
                                  ),
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
                                color: Theme.of(context).canvasColor,
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
                                                        2.2,
                                              ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 1),
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
                                                      2.2,
                                                ),
                                            text: '${Strings.txtLivesIn.tr} ',
                                            children: [
                                              TextSpan(
                                                text:
                                                    userData.village.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2.2,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 1),
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
                                                      2.2,
                                                ),
                                            text: '${Strings.txtDep.tr} ',
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
                                                            2.2,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            SizeConfig.heightMultiplier * 1),
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
                                                      2.2,
                                                ),
                                            text: '${Strings.txtSartWork.tr} ',
                                            children: [
                                              TextSpan(
                                                text: DateFormatUtil.formatA(
                                                    DateTime.parse(userData
                                                        .workStartDate!)),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        fontSize: SizeConfig
                                                                .textMultiplier *
                                                            2.2,
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
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       "Award(5)",
                                //       style: Theme.of(context)
                                //           .textTheme
                                //           .titleLarge!
                                //           .copyWith(
                                //               fontSize:
                                //                   SizeConfig.textMultiplier *
                                //                       2),
                                //     ),
                                //     InkWell(
                                //       onTap: () {
                                //         buildShowAwardModalBottomSheet(context);
                                //       },
                                //       child: Text(
                                //         "See all",
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .titleLarge!
                                //             .copyWith(
                                //                 fontSize:
                                //                     SizeConfig.textMultiplier *
                                //                         2),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(
                                //     height: SizeConfig.heightMultiplier * 1),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: SizedBox(
                                //         height: SizeConfig.heightMultiplier *
                                //             15, // Adjust size as needed
                                //         child: ListView.builder(
                                //           padding: EdgeInsets.zero,
                                //           scrollDirection: Axis.horizontal,
                                //           itemCount: wardData.length,
                                //           itemBuilder: (context, index) {
                                //             return Padding(
                                //               padding: const EdgeInsets.only(
                                //                   right: 16.0),
                                //               child: Column(
                                //                 children: [
                                //                   Image.asset(
                                //                     wardData[index]['icons']
                                //                         .toString(),
                                //                     width: 90,
                                //                     fit: BoxFit.cover,
                                //                   ),
                                //                   const SizedBox(height: 8),
                                //                   Expanded(
                                //                     child: Text(
                                //                       wardData[index]['name']
                                //                           .toString(),
                                //                       style: Theme.of(context)
                                //                           .textTheme
                                //                           .bodyMedium!
                                //                           .copyWith(),
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             );
                                //           },
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Text(
                            //   "Passion & Skills",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .titleLarge!
                            //       .copyWith(
                            //           fontSize: SizeConfig.textMultiplier * 2),
                            // ),
                            // SizedBox(height: SizeConfig.heightMultiplier * 1),
                            // Wrap(
                            //   spacing: 10,
                            //   runSpacing: 10,
                            //   children: skillsData.map((skill) {
                            //     return Container(
                            //       margin: const EdgeInsets.only(top: 10),
                            //       padding: const EdgeInsets.all(8.0),
                            //       decoration: BoxDecoration(
                            //         color: Theme.of(context).cardColor,
                            //         borderRadius: BorderRadius.circular(50),
                            //         border: Border.all(
                            //           color: Theme.of(context).cardColor,
                            //           width: 1.0,
                            //         ),
                            //       ),
                            //       child: Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //           SizedBox(
                            //               width:
                            //                   SizeConfig.widthMultiplier * 1),
                            //           Row(
                            //             children: [
                            //               Text(
                            //                 skill['name'],
                            //                 overflow: TextOverflow.ellipsis,
                            //                 style: Theme.of(context)
                            //                     .textTheme
                            //                     .bodyMedium!
                            //                     .copyWith(),
                            //               ),
                            //             ],
                            //           )
                            //         ],
                            //       ),
                            //     );
                            //   }).toList(),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 120,
                  child: Container(
                    width: 162,
                    height: 162,
                    decoration: ShapeDecoration(
                      shape: DottedBorder(
                        dotSize: 9,
                        dotSpacing: 8,
                        borderRadius: BorderRadius.circular(
                            81), // Match CircleAvatar radius
                        gradient: LinearGradient(
                          colors: headerProfileColor,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: GestureDetector(
                        onTap: () {
                          bottomSheetPushContainer(
                            context: context,
                            constantsSize: 1,
                            child: buttonChooseImageProfile(context),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: kTextWhiteColor,
                          radius: 70,
                          child: _imageFile != null && _croppedFile != null
                              ? Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 67,
                                      backgroundImage: FileImage(
                                        File(_croppedFile?.path ??
                                            _imageFile!.path),
                                      ),
                                      onBackgroundImageError: (_, __) =>
                                          const Icon(
                                        Icons.error,
                                        size: 30,
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
                                            child: buttonChooseImageProfile(
                                                context),
                                          );
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: kTextWhiteColor,
                                          radius: 20,
                                          child: CircleAvatar(
                                            backgroundColor: kGary,
                                            radius: 18,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: kBack,
                                            ),
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
                                      radius: 67,
                                      foregroundImage:
                                          CachedNetworkImageProvider(
                                              userData!.profile.toString()),
                                    ).animate().scaleXY(
                                          begin: 0,
                                          end: 1,
                                          delay: 500.ms,
                                          duration: 500.ms,
                                          curve: Curves.easeInOutCubic,
                                        ),
                                    Positioned(
                                      bottom: 5,
                                      right: -22,
                                      child: InkWell(
                                        onTap: () {
                                          bottomSheetPushContainer(
                                            context: context,
                                            child: buttonChooseImageProfile(
                                                context),
                                          );
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: kTextWhiteColor,
                                          radius: 25,
                                          child: CircleAvatar(
                                            backgroundColor: kGary,
                                            radius: 22,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: kBack,
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
                  ),
                ),
              ],
            );
          }),
        ),
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
                        child: const Icon(
                          Icons.camera_alt,
                          color: kBack,
                        ),
                      ),
                    ).animate().scaleXY(
                        begin: 0,
                        end: 1,
                        delay: 500.ms,
                        duration: 500.ms,
                        curve: Curves.easeInOutCubic),
                  ),
                ),
                Positioned(
                  bottom: 110.0,
                  right: 16.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingScreen()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: kTextWhiteColor,
                      radius: 19,
                      child: CircleAvatar(
                        backgroundColor: kGary,
                        radius: SizeConfig.heightMultiplier * 1.8,
                        child: const Icon(
                          Bootstrap.gear,
                          color: kBack,
                        ),
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
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: SizeConfig.textMultiplier * 2.2),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: SizeConfig.textMultiplier * 2),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: SizeConfig.textMultiplier * 2),
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
