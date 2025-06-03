import 'package:enterprise/components/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/constants/strings.dart';
import '../../../components/styles/size_config.dart';

class AlertCustomDialog extends StatelessWidget {
  const AlertCustomDialog({
    Key? key,
    required this.title,
    required this.content,
    this.actions,
    this.color = kYellowFirstColor,
    this.onTapOK,
  }) : super(key: key);

  final List<Widget>? actions;
  final Color color;
  final Widget title;
  final Widget content;
  final void Function()? onTapOK;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      title: Center(child: title),
      content: content,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFE4E4E7),
                  ),
                  child: Text(
                    Strings.txtCancel.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 2),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: onTapOK,
              child: Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: kYellowColor,
                  ),
                  child: Text(
                    Strings.txtOkay.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: SizeConfig.textMultiplier * 2),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AlertSuccessDialog extends StatelessWidget {
  const AlertSuccessDialog({
    Key? key,
    required this.title,
    this.content,
    this.actions,
    this.color = orangeColor,
    this.onTapOK,
    this.lottieIcon,
  }) : super(key: key);

  final List<Widget>? actions;
  final Color color;
  final Widget title;
  final Widget? content;
  final String? lottieIcon;
  final void Function()? onTapOK;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      title: title,
      content: content ?? const SizedBox(),
      actions: [
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: onTapOK,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: kYellowFirstColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 4),
                    blurRadius: 10,
                    color: Colors.grey.withOpacity(.2),
                  ),
                ],
              ),
              child: SizedBox(
                height: SizeConfig.heightMultiplier * 4,
                child: Center(
                  child: Text(
                    Strings.txtOkay.tr,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: SizeConfig.textMultiplier * 1.9,
                        ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AlertPlainDialog extends StatelessWidget {
  const AlertPlainDialog({
    Key? key,
    required this.title,
    this.content,
    required this.actions,
    this.color = orangeColor,
    required this.lottie,
  }) : super(key: key);

  final List<Widget> actions;
  final Color color;
  final String? title, content;
  final Widget lottie;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text(
        // textAlign: TextAlign.center,
        // text: title!,
        // color: color,
        '',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          lottie,
          const Text(
              // textAlign: TextAlign.center,
              // text: content!,
              //
              ''),
        ],
      ),
      actions: actions,
    );
  }
}

class AlertErrorDialog extends StatelessWidget {
  const AlertErrorDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
    required this.color,
    this.lottie,
  }) : super(key: key);

  final List<Widget> actions;
  final Color color;
  final String title, content;
  final Widget? lottie;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text(
        // textAlign: TextAlign.center,
        // text: title!,
        // color: color,
        '',
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              // textAlign: TextAlign.center,
              // text: content!,
              //
              ''),
        ],
      ),
      actions: actions,
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}

class AlertAction extends StatelessWidget {
  const AlertAction({
    Key? key,
    required this.onTap,
    required this.title,
    this.titleColor = kTextWhiteColor,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kTextWhiteColor,
        padding: const EdgeInsets.all(20),
        // child: TextNormal(
        //   text: title,
        //   color: titleColor!,
        // ),
        child: Text(''),
      ),
    );
  }
}

class AlertCancelAction extends StatelessWidget {
  const AlertCancelAction({Key? key, required this.onTap, required this.title})
      : super(key: key);

  final GestureTapCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kTextWhiteColor,
        padding: const EdgeInsets.all(20),
        child: Text(
          Strings.txtCancel.tr,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontSize: SizeConfig.textMultiplier * 2),
        ),
      ),
    );
  }
}

///iOS Dialog
class AlertIOSDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final void Function()? onPressed;
  final List? actions = const [];

  const AlertIOSDialog({
    Key? key,
    required this.title,
    required this.onPressed,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: CupertinoAlertDialog(
        title: title,
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              Strings.txtCancel.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 2),
            ),
          ),
          CupertinoDialogAction(
            onPressed: onPressed,
            child: Text(
              Strings.txtOkay.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: SizeConfig.textMultiplier * 2),
            ),
          ),
        ],
      ),
    );
  }
}

class AlertIOSSuccessDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final void Function()? onPressed;
  final List? actions = const [];

  const AlertIOSSuccessDialog({
    Key? key,
    required this.title,
    required this.onPressed,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: CupertinoAlertDialog(
        title: title,
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: onPressed,
            child: Text(
              Strings.txtOkay,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: SizeConfig.textMultiplier * 1.9,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
