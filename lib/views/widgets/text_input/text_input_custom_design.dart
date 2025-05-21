import 'package:enterprise/components/constants/colors.dart';
import 'package:enterprise/components/styles/size_config.dart';
import 'package:flutter/material.dart';

class CustomTextFieldDesign extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? focusedErrorBorder;
  final OutlineInputBorder? border;

  final int maxLines;
  final String? errorText;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final void Function(String)? onChanged;

  const CustomTextFieldDesign(
      {super.key,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixIconColor,
      this.suffixIconColor,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.enabledBorder,
      this.focusedBorder,
      this.errorBorder,
      this.focusedErrorBorder,
      this.maxLines = 1,
      this.errorText,
      this.validator,
      this.onChanged,
      this.hintStyle,
      this.border});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: false,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(color: prefixIconColor),
                child: prefixIcon!,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: IconThemeData(color: suffixIconColor),
                child: suffixIcon!,
              )
            : null,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: kGreyColor2, fontSize: SizeConfig.textMultiplier * 2),
        border: border ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),

        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: kGary, width: 1),
              borderRadius: BorderRadius.circular(15.0),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderSide:
                  const BorderSide(color: kYellowFirstColor, width: 0.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
        errorBorder: errorBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: kRedColor, width: 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
        focusedErrorBorder: focusedErrorBorder ??
            OutlineInputBorder(
              borderSide:
                  const BorderSide(color: kYellowFirstColor, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(width: 1, color: kGary),
        ),
        errorText: errorText,
        // errorStyle: const TextStyle(color: kRedColor),
        errorStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: kRedColor,
            ),
        fillColor: Theme.of(context).canvasColor,
        filled: true,
      ),
    );
  }
}
