import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/constants/error_strings.dart';
import 'package:enterprise/components/constants/key_shared.dart';
import 'package:enterprise/components/constants/strings.dart';
import 'package:enterprise/components/helpers/shared_prefs.dart';
import 'package:enterprise/components/logger/logger.dart';
import 'package:enterprise/components/router/router.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:enterprise/components/utils/dio_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

SharedPrefs sharedPrefs = SharedPrefs();
//
Future<void> errorDialog({BuildContext? context, required onError}) {
  if (onError != null) {
    if (onError.response != null &&
        onError.response!.data!['message'] == "Unauthenticated.") {
      return customDialog(
        context: context,
        title: ErrorMsg.txtError.tr,
        titleColor: Colors.red,
        content: Strings.txtLogout.tr,
        txtConfirm: Strings.txtYes.tr,
        txtCancel: Strings.txtNo.tr,
        cancelAction: () {
          Navigator.pop(context!);
        },
        confirmAction: () {
          Navigator.pop(context!);
        },
      );
    } else {
      String errorMessage = DioExceptions.fromDioError(onError).toString();

      switch (errorMessage) {
        case "Errors":
          errorMessage = ErrorMsg.txtError.tr;
          break;
        default:
          errorMessage = errorMessage;
      }
      return customDialog(
        context: context,
        title: ErrorMsg.txtError.tr,
        titleColor: Colors.red,
        content: errorMessage,
        txtConfirm: Strings.txtOkay.tr,
        showCancelButton: false,
        confirmAction: () {
          logger.d(errorMessage);
          if (errorMessage == "Unauthorized") {
            // final token = sharedPrefs.getStringNow(KeyShared.keyToken);

            sharedPrefs.remove(KeyShared.keyToken);

            context!.go(PageName.splashRoute);
          } else {
            context!.pop();
          }
        },
      );
    }
  } else {
    return customDialog(
      context: context,
      title: ErrorMsg.txtError.tr,
      titleColor: Colors.red,
      content: DioExceptions.fromDioError(onError).toString(),
      txtConfirm: Strings.txtOkay.tr,
      showCancelButton: false,
      confirmAction: () {
        Navigator.pop(context!);
      },
    );
  }
}

Future<dynamic> customDialog({
  BuildContext? context,
  int? index,
  String? title,
  Color? titleColor,
  Color? iconColor,
  Color? iconBackgroundColor,
  Color? buttonColor,
  String? content,
  String? txtCancel,
  String? txtConfirm,
  VoidCallback? cancelAction,
  VoidCallback? confirmAction,
  IconData? icon,
  bool? showCancelButton = true,
  Widget? imageWidget,
}) {
  return showDialog(
    barrierDismissible: false,
    context: context!,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        icon: imageWidget ??
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info,
                color: iconColor ?? Colors.white,
                size: SizeConfig.imageSizeMultiplier * 13,
              ),
            ),
        title: Text(
          title!,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
          textAlign: TextAlign.center,
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 15,
            vertical: SizeConfig.widthMultiplier * 2),
        content: Text(
          content!,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
          textAlign: TextAlign.center,
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 15),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showCancelButton!
                  ? Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: cancelAction,
                          child: Text(
                            txtCancel!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontSize: SizeConfig.textMultiplier * 1.9),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(width: showCancelButton ? 10 : 0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor ?? kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: confirmAction,
                    child: Text(
                      txtConfirm!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: SizeConfig.textMultiplier * 1.9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
