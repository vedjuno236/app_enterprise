import 'package:dio/dio.dart';
import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/image_path.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/poviders/dark_mode_provider/dark_mode_provider.dart';
import 'package:enterprise/components/poviders/login_providers/login_provider.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/services/api_service/enterprise_service.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/dialogs.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:enterprise/views/screens/auth/translate.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_login.dart';
import 'package:enterprise/views/widgets/loading_platform/loading_platform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  SharedPrefs sharedPrefs = SharedPrefs();
  bool isLoading = false;
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  bool validatePhone = false;
  String? selectedNumber = "+856 20";
  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final deviceToken = await FirebaseMessaging.instance.getToken();

    // logger.d('deviceToken CMF :$deviceToken');

    try {
      final response = await EnterpriseAPIService().loginAPI(
        phone: '20${phoneController.text}',
        password: passwordController.text,
        deviceToken: deviceToken,
      );
      if (response != null && response['status'] == true) {
        sharedPrefs.setStringNow(KeyShared.keyToken, response['access_token']);
        if (response['data'] != null && response['data']['id'] != null) {
          final userId = response['data']['id'].toString();
          final role = response['data']['role'].toString();
          sharedPrefs.setStringNow(KeyShared.keyUserId, userId);
          sharedPrefs.setStringNow(KeyShared.keyRole, role);

          logger.d(role);
        }
        // ignore: use_build_context_synchronously
        context.go(PageName.navigatorBarScreenRoute);
      } else {
        // _showAlertDialog(context, response['error']);
      }
    } catch (error) {
      if (error is DioException) {
        final dioError = DioExceptions.fromDioError(error);
        logger.e('Login Error: ${dioError.message}');
        errorDialog(context: context, onError: error);
      } else {
        logger.e('Unexpected Login Error: $error');
        errorDialog(context: context, onError: error);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme = ref.watch(darkThemeProviderProvider);

    final loginProvider = ref.watch(stateLoginProvider);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: CustomProgressHUD(
        color: Theme.of(context).scaffoldBackgroundColor,
        key: UniqueKey(),
        inAsyncCall: isLoading,
        opacity: .7,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: SizeConfig.heightMultiplier * 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const LanguageSwitcher()
                          .animate()
                          .fadeIn(duration: 900.ms, delay: 300.ms)
                          .move(
                              begin: const Offset(-16, 0),
                              curve: Curves.easeOutQuad),
                    ],
                  ),
                  Image.asset(
                    ImagePath.imgIconCreateAcc,
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  Text(
                    Strings.txtWelcome.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 3.5),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    Strings.txtEnterPhoneAndScanFace.tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: SizeConfig.textMultiplier * 2.2),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 300.ms)
                      .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.txtYourPhoneNumber.tr,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: SizeConfig.textMultiplier * 2),
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                          begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: _phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        inputFormatters: [
                          selectedNumber == "+856 30"
                              ? LengthLimitingTextInputFormatter(7)
                              : LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).canvasColor,
                          focusColor: kTextWhiteColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: kYellowFirstColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: kRedColor,
                                  fontSize: SizeConfig.textMultiplier * 1.9),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: kYellowFirstColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: kYellowFirstColor,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: Strings.txtEnterhonenumber.tr,
                          hintStyle:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.8,
                                  ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    ImagePath.iconFlagLaos,
                                  ),
                                  SizedBox(
                                      width: SizeConfig.widthMultiplier * 2),
                                  Text(
                                    selectedNumber!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2,
                                        ),
                                  ),
                                  Image.asset(
                                    'assets/images/ps.png',
                                    width: 10,
                                    height: 40,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                            ),
                        onChanged: (phone) {
                          if (phone.length > 8) {
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                          setState(() {});
                        },
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.length < 8 ||
                              value.contains(RegExp(r'[^\d-]'))) {
                            return Strings.txtPleaseEnterTheCorrectPhone.tr;
                          }

                          return null;
                        },
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                          begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                      ValidateAlert(
                        visible: validatePhone,
                        title: Strings.txtPleaseEnterTheCorrectPhone.tr,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      Text(
                        Strings.txtPassword.tr,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                            ),
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                          begin: const Offset(-16, 0),
                          curve: Curves.easeOutQuad),
                      SizedBox(height: SizeConfig.heightMultiplier * 1),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: _passwordFocusNode,
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).canvasColor,
                          focusColor: kTextWhiteColor,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: kYellowFirstColor, width: 1.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: kYellowFirstColor, width: 1.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: kYellowFirstColor, width: 1.0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: Strings.txtPleaseEnterYourPassword.tr,
                          hintStyle:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.8,
                                  ),
                          errorStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: kRedColor,
                                  fontSize: SizeConfig.textMultiplier * 1.9),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Image.asset(
                              ImagePath.iconPassword,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref.read(stateLoginProvider).passwordVisibility =
                                  !ref
                                      .read(stateLoginProvider)
                                      .passwordVisibility;
                            },
                            icon: Icon(
                              loginProvider.passwordVisibility
                                  ? FontAwesome.eye_slash
                                  : FontAwesome.eye,
                              size: 20,
                              color: kGreyColor2,
                            ),
                          ),
                        ),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                            ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return Strings.txtPleaseEnterTheCorrectPassword.tr;
                          }

                          return null;
                        },
                        obscureText: loginProvider.passwordVisibility,
                      ).animate().fadeIn(duration: 900.ms, delay: 300.ms).move(
                          begin: Offset(-16, 0), curve: Curves.easeOutQuad),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              // selectedNumber == null ||
              //         phoneController.text.isEmpty ||
              //         passwordController.text.isEmpty ||
              //         selectedNumber == "+856 30"
              //     ? phoneController.text.length < 7 ||
              //             phoneController.text.contains(RegExp(r'[^\d-]'))
              //         ? null
              //         : () {
              //             login();
              //           }
              //     : phoneController.text.length < 8 ||
              //             phoneController.text.contains(RegExp(r'[^\d-]'))
              //         ? null
              //         : () {
              //             login();
              //           };

              login();
            }
          },
          child: Container(
            width: SizeConfig.widthMultiplier * 100,
            height: SizeConfig.heightMultiplier * 6,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (selectedNumber == null ||
                      selectedNumber == "+856 30" ||
                      phoneController.text.isEmpty)
                  ? (phoneController.text.length < 7 ||
                          phoneController.text.contains(RegExp(r'[^\d-]')))
                      ? darkTheme.darkTheme
                          ? kBack
                          : kYellowFirstColor.withOpacity(.5)
                      : darkTheme.darkTheme
                          ? kBack
                          : kYellowFirstColor // Corrected this line
                  : (phoneController.text.length < 8 ||
                          phoneController.text.contains(RegExp(
                              r'[^\d-]'))) // Removed the redundant else if
                      ? darkTheme.darkTheme
                          ? kBack
                          : kYellowFirstColor.withOpacity(.5)
                      : darkTheme.darkTheme
                          ? kBack
                          : kYellowFirstColor, // corrected this line
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: isLoading
                  // ? const CupertinoActivityIndicator(
                  //     color: kTextWhiteColor,
                  //     radius: 20,
                  //   )
                  ? const LoadingPlatformV2(
                      size: 20,
                    )
                  : Text(
                      Strings.txtNext.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            ),
          )
              .animate()
              .fadeIn(duration: 900.ms, delay: 300.ms)
              .shimmer(blendMode: BlendMode.srcOver, color: kGary)
              .move(begin: Offset(-16, 0), curve: Curves.easeOutQuad),
        ),
      ),
    );
  }
}

class ValidateAlert extends StatelessWidget {
  final bool visible;
  final String title;

  const ValidateAlert({
    Key? key,
    required this.visible,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
