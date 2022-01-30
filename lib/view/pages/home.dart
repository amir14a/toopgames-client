import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:toopgames_client/main.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/extension_funs.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/widgets/app_bars.dart';
import 'package:toopgames_client/view/widgets/buttons.dart';
import 'package:toopgames_client/view/widgets/loading.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:toopgames_client/viewmodel/home_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewModel = HomeViewModel();
  var pageIndex = 0;

  @override
  void initState() {
    _viewModel.addListener(() => setState(() {}));
    _viewModel.statsRequestState.addListener(() {
      if (_viewModel.statsRequestState.isSending()) {
        showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) =>
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                  child: Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppLoading(
                                  padding: EdgeInsets.all(24),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ));
      }
      if (_viewModel.statsRequestState.isSuccess()) {
        var stats = _viewModel.statsResponse.value!.data!;
        Navigator.pop(context);
        showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) =>
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                  child: Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: stats.rate == 1
                                        ? AppColors.gold
                                        : stats.rate == 2
                                        ? AppColors.silver
                                        : stats.rate == 3
                                        ? AppColors.bronze
                                        : AppColors.primary,
                                    child: FittedBox(
                                      child: AppText(
                                        "${stats.rate ?? 1}",
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const AppText.secondary("رتبه"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: AppColors.bg,
                                      child: FittedBox(
                                          child: stats.user?.avatarAddress != null
                                              ? Image.network(
                                            stats.user!.avatarAddress!,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          )
                                              : const Icon(
                                            Icons.person,
                                            color: AppColors.textSecondary,
                                          )),
                                    ),
                                  ),
                                  AppText("${stats.user?.name ?? stats.user?.userId}"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.textSuccess,
                                      child: FittedBox(
                                        child: AppText(
                                          "${stats.wins ?? 0}",
                                          textColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    AppText.secondary(
                                      "تعداد برد (${stats.winRate ?? 0}%)",
                                      textColor: AppColors.textSuccess,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: AppText.secondary(
                                  "تعداد بازی: ${stats.games ?? 0}",
                                  textColor: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: AppText.secondary(
                                  "تعداد تساوی: ${stats.draws ?? 0}",
                                  textColor: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: AppText.secondary(
                                  "تعداد باخت: ${stats.losses ?? 0}",
                                  textColor: AppColors.textFailed,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: AppText.secondary(
                                  "تاریخ عضویت: ${stats.user?.createdOn.toDate()?.formatDateAndTime()}",
                                  textAlign: TextAlign.center,
                                  textColor: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            const Expanded(child: Center(),),
                            Expanded(
                              child: Center(
                                child: AppText.secondary(
                                  "تاریخ آخرین بازی: ${stats.updatedOn.toDate()?.formatDateAndTime()}",
                                  textAlign: TextAlign.center,
                                  textColor: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ));
        if (_viewModel.statsRequestState.isFailed()) {
          Navigator.pop(context);
          context.showSnackBar("خطا در ارتباط");
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: EmptyAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (pageIndex == 0)
                          Column(
                            children: [
                              const SizedBox(height: 48),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child:
                                        Image.asset("assets/imgs/memory-card-pi.png", height: 100, width: 100),
                                      ),
                                      Container(
                                        // margin: const EdgeInsets.all(16),
                                        constraints: const BoxConstraints(minHeight: 100),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            AppColors.getCardColor(1).withOpacity(.5),
                                            AppColors.getCardColor(1)
                                          ]),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 0), color: AppColors.shadow, blurRadius: 12)
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, AppPages.memoryCard);
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Row(
                                              textDirection: TextDirection.rtl,
                                              children: const [
                                                Icon(
                                                  AntDesign.caretright,
                                                  size: 56,
                                                  color: Colors.white,
                                                ),
                                                Expanded(
                                                    child: AppText(
                                                      "بازی کارت حافظه",
                                                      textColor: Colors.white,
                                                    )),
                                                SizedBox(
                                                  width: 100,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset("assets/imgs/quiz.png", height: 100, width: 100),
                                      ),
                                      Container(
                                        // margin: const EdgeInsets.all(16),
                                        constraints: const BoxConstraints(minHeight: 100),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            AppColors.getCardColor(3).withOpacity(.5),
                                            AppColors.getCardColor(3)
                                          ]),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 0), color: AppColors.shadow, blurRadius: 12)
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, AppPages.quiz);
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Row(
                                              textDirection: TextDirection.rtl,
                                              children: const [
                                                Icon(
                                                  AntDesign.caretright,
                                                  size: 56,
                                                  color: Colors.white,
                                                ),
                                                Expanded(
                                                    child: AppText(
                                                      "بازی کوییز اطلاعات عمومی",
                                                      textColor: Colors.white,
                                                    )),
                                                SizedBox(
                                                  width: 100,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.asset("assets/imgs/typing.png", height: 100, width: 100),
                                      ),
                                      Container(
                                        // margin: const EdgeInsets.all(16),
                                        constraints: const BoxConstraints(minHeight: 100),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            AppColors.getCardColor(2).withOpacity(.5),
                                            AppColors.getCardColor(2)
                                          ]),
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 0), color: AppColors.shadow, blurRadius: 12)
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, AppPages.typingTest);
                                            },
                                            borderRadius: BorderRadius.circular(16),
                                            child: Row(
                                              textDirection: TextDirection.rtl,
                                              children: const [
                                                Icon(
                                                  AntDesign.caretright,
                                                  size: 56,
                                                  color: Colors.white,
                                                ),
                                                Expanded(
                                                    child: AppText(
                                                      "بازی سرعت تایپ",
                                                      textColor: Colors.white,
                                                    )),
                                                SizedBox(
                                                  width: 100,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 64),
                            ],
                          ),
                        if (pageIndex == 1)
                          Column(
                            children: [
                              const SizedBox(height: 48),
                              if (_viewModel.matchesRequestState.isSending()) const AppLoading(),
                              if (_viewModel.matchesRequestState.isSuccess())
                                if (_viewModel.matchesResponse.value?.success == true)
                                  for (var match in _viewModel.matchesResponse.value!.data!)
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 0),
                                              color: AppColors.shadow,
                                              blurRadius: 12,
                                              spreadRadius: 4,
                                            )
                                          ]),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: AppText.secondary(
                                              "بازی ${match?.gameName}",
                                              textColor: AppColors.primaryDark,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Stack(
                                                        alignment: Alignment.bottomRight,
                                                        children: [
                                                          ClipOval(
                                                            child: CircleAvatar(
                                                              radius: 36,
                                                              backgroundColor: AppColors.bg,
                                                              child: FittedBox(
                                                                  child: match?.firstUser?.avatarAddress != null
                                                                      ? Image.network(
                                                                    match!.firstUser!.avatarAddress!,
                                                                    fit: BoxFit.cover,
                                                                    width: 72,
                                                                    height: 72,
                                                                  )
                                                                      : const Icon(
                                                                    Icons.person,
                                                                    color: AppColors.textSecondary,
                                                                  )),
                                                            ),
                                                          ),
                                                          CircleAvatar(
                                                            radius: 12,
                                                            child: FittedBox(
                                                              child: AppText(
                                                                "${match?.firstUserScore ?? 0}",
                                                                textColor: Colors.white,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      AppText(
                                                          "${match?.firstUser?.name ?? match?.firstUser?.userId}"),
                                                    ],
                                                  )),
                                              AppText.title(
                                                  "${match?.firstUserScore ?? 0} - ${match?.secondUserScore ??
                                                      0}"),
                                              Expanded(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Stack(
                                                        alignment: Alignment.bottomRight,
                                                        children: [
                                                          ClipOval(
                                                            child: CircleAvatar(
                                                              radius: 36,
                                                              backgroundColor: AppColors.bg,
                                                              child: FittedBox(
                                                                  child: match?.secondUser?.avatarAddress != null
                                                                      ? Image.network(
                                                                    match!.secondUser!.avatarAddress!,
                                                                    fit: BoxFit.cover,
                                                                    width: 72,
                                                                    height: 72,
                                                                  )
                                                                      : const Icon(
                                                                    Icons.person,
                                                                    color: AppColors.textSecondary,
                                                                  )),
                                                            ),
                                                          ),
                                                          CircleAvatar(
                                                            radius: 12,
                                                            child: FittedBox(
                                                              child: AppText(
                                                                "${match?.secondUserScore ?? 0}",
                                                                textColor: Colors.white,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      AppText(
                                                          "${match?.secondUser?.name ??
                                                              match?.secondUser?.userId}"),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Center(
                                            child: AppText.secondary(
                                              match?.createdOn.toDate()?.formatDateAndTime(),
                                              textDirection: TextDirection.ltr,
                                              textSize: AppTextSizes.verySmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AppText.secondary(_viewModel.matchesResponse.value?.message),
                                  ),
                              if (_viewModel.matchesRequestState.isFailed())
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const AppText.secondary("خطا در دریافت اطلاعات"),
                                        AppButton(
                                          text: "تلاش مجدد",
                                          onTap: _viewModel.getUserMatches,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 64),
                            ],
                          ),
                        if (pageIndex == 2)
                          Column(
                            children: [
                              const SizedBox(height: 48),
                              if (_viewModel.topsRequestState.isSending()) const AppLoading(),
                              if (_viewModel.topsRequestState.isSuccess())
                                if (_viewModel.topsResponse.value?.success == true)
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(0, 0),
                                            color: AppColors.shadow,
                                            blurRadius: 12,
                                            spreadRadius: 4,
                                          )
                                        ]),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        for (var stats in _viewModel.topsResponse.value!.data!)
                                          Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 24,
                                                          backgroundColor: _viewModel.topsResponse.value!.data!
                                                              .indexOf(stats) ==
                                                              0
                                                              ? AppColors.gold
                                                              : _viewModel.topsResponse.value!.data!
                                                              .indexOf(stats) ==
                                                              1
                                                              ? AppColors.silver
                                                              : _viewModel.topsResponse.value!.data!
                                                              .indexOf(stats) ==
                                                              2
                                                              ? AppColors.bronze
                                                              : AppColors.primary,
                                                          child: FittedBox(
                                                            child: AppText(
                                                              "${_viewModel.topsResponse.value!.data!.indexOf(
                                                                  stats) + 1}",
                                                              textColor: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        const AppText.secondary("رتبه"),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        ClipOval(
                                                          child: CircleAvatar(
                                                            radius: 40,
                                                            backgroundColor: AppColors.bg,
                                                            child: FittedBox(
                                                                child: stats?.user?.avatarAddress != null
                                                                    ? Image.network(
                                                                  stats!.user!.avatarAddress!,
                                                                  fit: BoxFit.cover,
                                                                  width: 80,
                                                                  height: 80,
                                                                )
                                                                    : const Icon(
                                                                  Icons.person,
                                                                  color: AppColors.textSecondary,
                                                                )),
                                                          ),
                                                        ),
                                                        AppText("${stats?.user?.name ?? stats?.user?.userId}"),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 24,
                                                            backgroundColor: AppColors.textSuccess,
                                                            child: FittedBox(
                                                              child: AppText(
                                                                "${stats?.wins ?? 0}",
                                                                textColor: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                          AppText.secondary(
                                                            "تعداد برد (${stats?.winRate ?? 0}%)",
                                                            textColor: AppColors.textSuccess,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                      child: AppText.secondary(
                                                        "تعداد بازی: ${stats?.games ?? 0}",
                                                        textColor: AppColors.primaryDark,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: AppText.secondary(
                                                        "تعداد تساوی: ${stats?.draws ?? 0}",
                                                        textColor: AppColors.textSecondary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: AppText.secondary(
                                                        "تعداد باخت: ${stats?.losses ?? 0}",
                                                        textColor: AppColors.textFailed,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(endIndent: 8, indent: 8)
                                            ],
                                          )
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AppText.secondary(_viewModel.topsResponse.value?.message),
                                  ),
                              if (_viewModel.topsRequestState.isFailed())
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const AppText.secondary("خطا در دریافت اطلاعات"),
                                        AppButton(
                                          text: "تلاش مجدد",
                                          onTap: _viewModel.getTopUsers,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 64),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            height: 48,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.primary.withOpacity(.90),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 48),
                      Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 12, top: 12),
                              child: FittedBox(
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  children: const [
                                    AppText.title(
                                      "T",
                                      textColor: Colors.white,
                                    ),
                                    Icon(Ionicons.md_football_outline, color: Colors.white, size: 48 - 16),
                                    Icon(Ionicons.md_football_outline, color: Colors.white, size: 48 - 16),
                                    AppText.title(
                                      "PGames",
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                      PopupMenuButton<int>(
                        padding: EdgeInsets.zero,
                        elevation: 8,
                        onSelected: (val) async {
                          switch (val) {
                            case 0:
                              _viewModel.getUserStats();
                              break;
                            case 1:
                              showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (_) =>
                                      BackdropFilter(
                                        filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                        child: Dialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(32.0),
                                              child: AppText(
                                                "AmirAbbas Jannatian 2022\nBahman 1400",
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                      ));
                              break;
                            case 2:
                              await AppSharedPreferences.clearAll();
                              Navigator.pushReplacementNamed(context, AppPages.login);
                              break;
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        itemBuilder: (context) =>
                        [
                          const PopupMenuItem(
                            value: 0,
                            child: const AppText("پروفایل", textSize: AppTextSizes.small),
                            height: 36,
                          ),
                          const PopupMenuItem(
                            value: 1,
                            child: AppText("درباره ما", textSize: AppTextSizes.small),
                            height: 36,
                          ),
                          const PopupMenuItem(
                              value: 2,
                              height: 36,
                              child: AppText(
                                "خروج از حساب",
                                textSize: AppTextSizes.small,
                                textColor: AppColors.textFailed,
                              )),
                        ],
                        icon: const Icon(MaterialIcons.more_vert, size: 24, color: Colors.white),
                        tooltip: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.9),
                        borderRadius: const BorderRadius.only(
                            topRight: const Radius.circular(20), topLeft: const Radius.circular(20))),
                    child: BottomNavigationBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      selectedIconTheme: const IconThemeData(size: 32),
                      selectedItemColor: Colors.white,
                      currentIndex: pageIndex,
                      unselectedItemColor: Colors.white.withOpacity(.4),
                      onTap: (i) {
                        setState(() {
                          pageIndex = i;
                          if (i == 1) {
                            _viewModel.getUserMatches();
                          }
                          if (i == 2) {
                            _viewModel.getTopUsers();
                          }
                        });
                      },
                      items: const [
                        BottomNavigationBarItem(icon: Icon(AntDesign.caretright), label: "بازی جدید"),
                        BottomNavigationBarItem(icon: Icon(Fontisto.history), label: "آخرین بازی ها"),
                        BottomNavigationBarItem(icon: Icon(Ionicons.stats_chart), label: "آمار برترین ها"),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
