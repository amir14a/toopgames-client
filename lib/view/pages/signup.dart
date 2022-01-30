import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toopgames_client/main.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/extension_funs.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/widgets/app_bars.dart';
import 'package:toopgames_client/view/widgets/buttons.dart';
import 'package:toopgames_client/view/widgets/image_picker.dart';
import 'package:toopgames_client/view/widgets/inputs.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:toopgames_client/viewmodel/sign_up_view_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var pass2Ctrl = TextEditingController();
  var nameCtrl = TextEditingController();
  var userIdCtrl = TextEditingController();
  final ValueNotifier<XFile?> imageFile = ValueNotifier(null);
  final _viewModel = SignUpViewModel();

  bool isFormValid() {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty || pass2Ctrl.text.isEmpty || userIdCtrl.text.isEmpty) {
      context.showSnackBar("لطفا تمامی فیلد های ضروری را پر نمایید.");
      return false;
    }
    if (!emailCtrl.text.isValidEmail()) {
      context.showSnackBar("لطفا یک ایمیل معتبر وارد نمایید.");
      return false;
    }
    if (passCtrl.text != pass2Ctrl.text) {
      context.showSnackBar("تکرار رمز عبور با رمز عبور وارد شده متفاوت است.");
      return false;
    }
    if (userIdCtrl.text.length < 4) {
      context.showSnackBar("نام کاربری باید حداقل ۴ کاراکتر باشد.");
      return false;
    }
    return true;
  }

  @override
  void initState() {
    _viewModel.addListener(() => setState(() {}));
    _viewModel.response.addListener(() async {
      var response = _viewModel.response.value!;
      if (response.success) {
        if (response.data != null) await AppSharedPreferences.saveUser(response.data!);
        context.showSnackBar("خوش آمدید");
        Navigator.pushNamedAndRemoveUntil(context, AppPages.home, (route) => false);
      } else {
        context.showSnackBar(response.message);
      }
    });
    _viewModel.requestState.addListener(() {
      if (_viewModel.requestState.isFailed()) {
        context.showSnackBar("خطا در ارتباط، لطفا اتصال اینترنتی خود را بررسی کنید.");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: Stack(
        children: [
          Container(
            color: AppColors.primary,
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle),
                          child: const Icon(
                            MaterialIcons.add_a_photo,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        AppImagePicker(
                          imageFile: imageFile,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(top: 120),
            decoration: const BoxDecoration(
                color: AppColors.bg,
                boxShadow: [BoxShadow(blurRadius: 16, color: AppColors.shadow)],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                )),
            child: LayoutBuilder(builder: (context, cons) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: cons.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText.title("ثبت نام"),
                          const AppText.secondary("لطفا اطلاعات ورود خود را وارد نمایید."),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            color: AppColors.shadow,
                            height: 6,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const AppText("ایمیل"),
                          const SizedBox(height: 4),
                          AppInput(controller: emailCtrl, icon: const Icon(Icons.email)),
                          const SizedBox(height: 16),
                          const AppText("نام کاربری"),
                          const SizedBox(height: 4),
                          AppInput(controller: userIdCtrl, icon: const Icon(Icons.person)),
                          const SizedBox(height: 16),
                          const AppText("رمز عبور"),
                          const SizedBox(height: 4),
                          AppInput(controller: passCtrl, icon: const Icon(Icons.password), isPassword: true),
                          const SizedBox(height: 16),
                          const AppText("تکرار رمز عبور"),
                          const SizedBox(height: 4),
                          AppInput(controller: pass2Ctrl, icon: const Icon(Icons.password), isPassword: true),
                          const SizedBox(height: 16),
                          const AppText("نام نمایشی"),
                          const AppText.secondary(
                            "در صورتی که این مقدار را وارد نکنید، نام کاربری شما به کاربران نمایش داده خواهد شد.",
                            textSize: AppTextSizes.verySmall,
                          ),
                          const SizedBox(height: 4),
                          AppInput(controller: nameCtrl, icon: const Icon(Icons.person)),
                          const SizedBox(height: 16),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: AppButton(
                                      isLoading: _viewModel.requestState.isSending(),
                                      text: "ثبت نام",
                                      onTap: () {
                                        if (isFormValid()) {
                                          _viewModel.doSignUp(emailCtrl.text, passCtrl.text, nameCtrl.text,
                                              userIdCtrl.text, imageFile.value);
                                        }
                                      })),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
