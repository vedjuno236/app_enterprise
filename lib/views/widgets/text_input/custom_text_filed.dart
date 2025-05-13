import 'package:enterprise/components/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
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
  final int maxLines;
  final String? errorText;
  final String? Function(String?)? validator;
  final TextStyle? hintStyle;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        // hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
        //       color: kGreyColor2,
        //     ),
        hintStyle: hintStyle,
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
        errorText: errorText,
        errorStyle: const TextStyle(color: kRedColor),
        fillColor: Theme.of(context).canvasColor,
        filled: true,
      ),
    );
  }
}
