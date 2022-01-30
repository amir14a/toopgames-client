import 'package:flutter/material.dart';
import 'package:toopgames_client/main.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/extension_funs.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/widgets/app_bars.dart';
import 'package:toopgames_client/view/widgets/buttons.dart';
import 'package:toopgames_client/view/widgets/inputs.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:toopgames_client/viewmodel/login_view_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var userCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  final _viewModel = LoginViewModel();

  @override
  void initState() {
    _viewModel.addListener(() => setState(() {}));
    _viewModel.response.addListener(() async {
      var response = _viewModel.response.value!;
      if (response.success) {
        if (response.data != null) await AppSharedPreferences.saveUser(response.data!);
        context.showSnackBar("خوش آمدید");
        Navigator.pushReplacementNamed(context, AppPages.home);
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
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120),
            decoration: const BoxDecoration(
                color: AppColors.bg,
                boxShadow: [BoxShadow(blurRadius: 16, color: AppColors.shadow)],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                )),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText.title("ورود"),
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
                  const AppText("نام کاربری یا ایمیل"),
                  const SizedBox(height: 4),
                  AppInput(
                    controller: userCtrl,
                    icon: const Icon(Icons.person),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    hint: "مثال: a.abbasj@yahoo.com, amir_a14",
                  ),
                  const SizedBox(height: 16),
                  const AppText("رمز عبور"),
                  const SizedBox(height: 4),
                  AppInput(
                    controller: passCtrl,
                    icon: const Icon(Icons.password),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: AppButton(
                        text: "ورود",
                        isLoading: _viewModel.requestState.isSending(),
                        onTap: () {
                          if (userCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty) {
                            _viewModel.doLogin(userCtrl.text, passCtrl.text);
                          } else {
                            context.showSnackBar("لطفا تمامی فیلد ها را پر نمایید.");
                          }
                        },
                      )),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppPages.signUp);
                    },
                    child: Center(
                      child: RichText(
                          text: const TextSpan(
                              text: "در صورتی که حساب کاربری ندارید،",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: AppTextSizes.small,
                                fontFamily: "Tanha",
                              ),
                              children: [
                            TextSpan(
                                text: " ثبت نام ",
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: AppTextSizes.small,
                                    fontFamily: "Tanha",
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: "کنید.",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: AppTextSizes.small,
                                  fontFamily: "Tanha",
                                )),
                          ])),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
