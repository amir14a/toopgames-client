import 'package:flutter/material.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/view/widgets/texts.dart';

class AppInput extends StatelessWidget {
  final String? hint;
  final Icon? icon;
  final bool? isPassword;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextEditingController? controller;

  const AppInput(
      {Key? key, this.hint, this.icon, this.isPassword, this.textAlign, this.textDirection, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(offset: Offset(0, 0), color: AppColors.shadow, blurRadius: 12)],
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        textDirection: textDirection,
        textAlign: textAlign ?? TextAlign.start,
        style: const TextStyle(fontSize: AppTextSizes.normal, fontFamilyFallback: [
          "Tanha",
          "Ubuntu",
        ]),
        obscureText: isPassword == true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: AppTextSizes.normal, fontFamilyFallback: [
            "Tanha",
            "Ubuntu",
          ]),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          prefixIcon: icon,
          prefixIconConstraints: const BoxConstraints(minHeight: 0),
        ),
      ),
    );
  }
}
