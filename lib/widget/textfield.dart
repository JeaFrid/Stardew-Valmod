import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stardewmods/theme/color.dart';
import 'package:stardewmods/widget/pressable.dart';

Container textfield({
  String? text,
  TextEditingController? textController,
  bool? obscureText,
  String? imageIcon,
  IconData? icon,
  IconData? onSucccessIcon,
  Function()? onSucccess,
  Function()? onTap,
  bool? readOnly,
  FontWeight? fontWeight,
  double? size,
  BoxConstraints? constraints,
  bool? nonMargin,
  List<BoxShadow>? boxShadow,
  Color? color,
  Color? bgColor,
  bool? nonLabel,
  List<TextInputFormatter>? inputFormatters,
  void Function()? onEditingComplete,
  void Function(String)? onChanged,
  int? maxLines = 1,
  TextInputType? keyboardType,
  Widget? suffix,
}) {
  TextField textFields = TextField(
    readOnly: readOnly ?? false,
    controller: textController,
    inputFormatters: inputFormatters,
    onEditingComplete: onEditingComplete,
    maxLines: maxLines,
    keyboardType: keyboardType,
    onChanged: onChanged,
    cursorColor: defaultColor,
    style: GoogleFonts.poppins(
      color: color ?? textColor,
      fontSize: size,
      fontWeight: fontWeight,
    ),
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      border: InputBorder.none,
      labelText: nonLabel != true ? text : null,
      labelStyle: nonLabel != true
          ? GoogleFonts.poppins(color: (color ?? textColor).withOpacity(0.5))
          : null,
      hintText: nonLabel == true ? text : null,
      hintStyle: nonLabel == true
          ? GoogleFonts.poppins(
              color: (color ?? textColor).withOpacity(0.5),
              fontSize: size,
              fontWeight: fontWeight,
            )
          : null,
      isDense: true,
    ),
  );

  return Container(
    padding: EdgeInsets.all(8),
    constraints: constraints,
    margin: nonMargin == true
        ? null
        : EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      boxShadow: boxShadow,
      borderRadius: BorderRadius.circular(5),
      color: bgColor ?? Colors.transparent,
    ),
    child: Stack(
      children: [
        Row(
          children: [
            Visibility(
              visible: imageIcon != null,
              child: Row(
                children: [
                  Image.asset(
                    imageIcon ?? "",
                    color: defaultColor,
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),
            Visibility(
              visible: icon != null,
              child: Row(
                children: [
                  Icon(icon ?? Icons.search, color: defaultColor, size: 20),
                  SizedBox(width: 12),
                ],
              ),
            ),
            Expanded(
              child: onTap != null
                  ? Pressable(
                      onTap: onTap,
                      child: AbsorbPointer(child: textFields),
                    )
                  : textFields,
            ),
            if (suffix != null) ...[
              const SizedBox(width: 8),
              suffix,
            ],
            Visibility(
              visible: onSucccess != null,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  SizedBox(width: 20, height: 20),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 6,
          top: 14,
          child: Visibility(
            visible: onSucccess != null,
            child: Pressable(
              onTap: () {
                if (onSucccess != null) {
                  onSucccess();
                }
              },
              child: onSucccessIcon != null
                  ? Icon(onSucccessIcon, size: 22, color: textColor)
                  : Image.asset(
                      "assets/send.png",
                      color: defaultColor,
                      width: 20,
                      height: 20,
                    ),
            ),
          ),
        ),
      ],
    ),
  );
}
