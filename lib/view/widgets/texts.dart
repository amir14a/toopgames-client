import 'package:flutter/material.dart';
import 'package:toopgames_client/util/colors.dart';

class AppTextSizes {
  static const double verySmall = 12;
  static const double small = 16;
  static const double normal = 18;
  static const double large = 20;
  static const double title = 32;
}

class AppText extends StatelessWidget {
  final String? text;
  final String? fontFamily;
  final Color? textColor;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final TextDirection? textDirection;
  final double? textSize;
  final int? maxLines;

  const AppText(
    this.text, {
    Key? key,
    this.textColor,
    this.textAlign,
    this.textStyle,
    this.textDirection,
    this.textSize,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  const AppText.secondary(
    this.text, {
    Key? key,
    this.textColor = AppColors.textSecondary,
    this.textAlign,
    this.textStyle,
    this.textDirection,
    this.textSize = AppTextSizes.small,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  const AppText.title(
    this.text, {
    Key? key,
    this.textColor = AppColors.textNormal,
    this.textAlign,
    this.textStyle,
    this.textDirection,
    this.textSize = AppTextSizes.title,
    this.fontFamily,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection ?? TextDirection.rtl,
      style: textStyle ??
          TextStyle(
              fontFamily: (fontFamily ?? "Tanha"),
              fontFamilyFallback: const [
                "Ubuntu",
              ],
              fontSize: (textSize ?? AppTextSizes.normal),
              color: textColor ?? AppColors.textNormal),
    );
  }
}
