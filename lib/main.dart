import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/pages/home.dart';
import 'package:toopgames_client/view/pages/login.dart';
import 'package:toopgames_client/view/pages/memory_card.dart';
import 'package:toopgames_client/view/pages/quiz.dart';

// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:toopgames_client/view/pages/signup.dart';
import 'package:toopgames_client/view/pages/typing_test.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // setUrlStrategy(PathUrlStrategy()); //this remove # from url
    var firstPage = AppPages.login;
    if (await AppSharedPreferences.getUser() != null) {
      firstPage = AppPages.home;
    }
    runApp(ToopGamesApp(
      firstPage: firstPage,
    ));
  }, (error, st) => print(error));
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class AppPages {
  static const login = "/login";
  static const signUp = "/signUp";
  static const home = "/home";
  static const memoryCard = "/memoryCard";
  static const typingTest = "/typingTest";
  static const quiz = "/quiz";
}

class ToopGamesApp extends StatelessWidget {
  final String firstPage;

  const ToopGamesApp({Key? key, required this.firstPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) return Container();
        return Directionality(textDirection: TextDirection.rtl, child: child);
      },
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primarySwatch: Colors.indigo,
        primaryColorDark: AppColors.primaryDark,
        fontFamily: "Tanha",
      ),
      initialRoute: firstPage,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppPages.signUp:
            return MaterialPageRoute(builder: (c) => const SignUp());
          case AppPages.login:
            return MaterialPageRoute(builder: (c) => const Login());
          case AppPages.home:
            return MaterialPageRoute(builder: (c) => const HomePage());
          case AppPages.memoryCard:
            return MaterialPageRoute(builder: (c) => const MemoryCardPage());
          case AppPages.typingTest:
            return MaterialPageRoute(builder: (c) => const TypingTestPage());
          case AppPages.quiz:
            return MaterialPageRoute(builder: (c) => const QuizPage());
        }
      },
    );
  }
}
