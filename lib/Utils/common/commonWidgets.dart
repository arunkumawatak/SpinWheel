import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spin_wheel/Utils/colorConst.dart';

Text commonText({
  required String title,
  Color color = Colors.white,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w500,
}) {
  return Text(
    title,
    style: GoogleFonts.merriweather(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ),
  );
}

InputDecoration textFieldDecoration({
  String? hint,
  Widget? prefixIcon,
  Color? fillColor,
}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    contentPadding: const EdgeInsets.all(8),
    filled: true,
    hintStyle: GoogleFonts.merriweather(color: blackColor.withOpacity(0.7)),
    fillColor: fillColor ?? lightGrey.withAlpha(100),
    counterText: '',
    hintText: hint ?? '',
    errorStyle: GoogleFonts.merriweather(color: Colors.red),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(25)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(25)),
    errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(25)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(25)),
  );
}

// BoxDecoration commonBoxDecoration(
//     {Color? color,
//     BorderRadius? borderRadius,
//     Color? borderColor,
//     bool? shadow,
//     Color? shadowColor,
//     double? spreadRadius}) {
//   return BoxDecoration(
//     color: color ?? primaryColor,
//     borderRadius: borderRadius ?? BorderRadius.circular(25),
//     border: Border.all(width: 1, color: borderColor ?? Colors.transparent),
//     boxShadow: [
//       if (shadow == true)
//         BoxShadow(
//           color: shadowColor ?? lightGrey,
//           blurRadius: 8.0, // soften the shadow
//           spreadRadius: spreadRadius ?? 1.0, //extend the shadow
//         )
//     ],
//   );
// }
