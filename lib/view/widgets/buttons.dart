import 'package:flutter/material.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/view/widgets/texts.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool? isLoading;
  final void Function()? onTap;

  const AppButton({Key? key, required this.text, this.isLoading, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(offset: Offset(0, 12), color: AppColors.primaryShadow, blurRadius: 12)],
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark])),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (isLoading == true) ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: isLoading == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                          width: AppTextSizes.large,
                          height: AppTextSizes.large,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                    ],
                  )
                : SizedBox(
                    height: AppTextSizes.large,
                    child: FittedBox(
                      child: AppText(
                        text,
                        textColor: Colors.white,
                        textSize: AppTextSizes.normal,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
