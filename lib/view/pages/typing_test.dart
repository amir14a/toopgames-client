import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:toopgames_client/model/game_state.dart';
import 'package:toopgames_client/model/typing_test_state.dart';
import 'package:toopgames_client/model/user_model.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/consts.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/widgets/app_bars.dart';
import 'package:toopgames_client/view/widgets/buttons.dart';
import 'package:toopgames_client/view/widgets/inputs.dart';
import 'package:toopgames_client/view/widgets/search.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TypingTestPage extends StatefulWidget {
  const TypingTestPage({Key? key}) : super(key: key);

  @override
  _TypingTestPageState createState() => _TypingTestPageState();
}

class _TypingTestPageState extends State<TypingTestPage> {
  GameState gameState = GameState.searching;
  String? error;
  int onlineCount = 0;
  TypingTestState? state;
  UserModel? user1;
  UserModel? user2;
  bool? isUser1;
  int? gameId;
  List<String>? words;
  late WebSocketChannel channel;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    channel = WebSocketChannel.connect(Uri.parse(Consts.typingTestUrl));
    channel.stream.listen((message) {
      var json = jsonDecode(message);
      if (json["action"] == "connection_open") {
        setState(() {
          onlineCount = json["content"]["online_users"];
        });
        AppSharedPreferences.getUser().then((value) => channel.sink.add(jsonEncode({
              "action": "set_user",
              "content": value?.toJson(),
            })));
      } else if (json["action"] == "start_game") {
        setState(() {
          gameState = GameState.duringGame;
          user1 = UserModel.fromJson(json["content"]["player1"]);
          user2 = UserModel.fromJson(json["content"]["player2"]);
          words = json["content"]["words"].cast<String>();
          isUser1 = json["content"]["is_player1"];
          gameId = json["content"]["game_id"];
        });
      } else if (json["action"] == "update_game") {
        setState(() {
          state = TypingTestState.fromJson(json["content"]);
          if (state?.endGame == true) {
            gameState = GameState.endOfGame;
          }
        });
      } else if (json["action"] == "error") {
        channel.sink.close(goingAway);
        setState(() {
          error = json["content"];
          gameState = GameState.error;
        });
      }
    }, onError: (e) {
      setState(() {
        error = e.toString();
        gameState = GameState.error;
      });
      print("error in connection: $error");
    }, onDone: () {
      setState(() {
        gameState = GameState.error;
      });
    }, cancelOnError: true);

    controller.addListener(() {
      setState(() {});
      if (controller.text.endsWith(" ")) {
        var word = controller.text.replaceAll(" ", "");
        controller.text = "";
        channel.sink.add(jsonEncode({
          "action": "type_word",
          "content": {
            "game_id": gameId,
            "word": word,
          }
        }));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close(goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        channel.sink.close(goingAway);
        return true;
      },
      child: Scaffold(
        appBar: EmptyAppBar(),
        backgroundColor: AppColors.bg,
        body: Stack(
          children: [
            if (gameState == GameState.duringGame)
              Column(
                children: [
                  LinearProgressIndicator(
                    color: AppColors.timeColor,
                    backgroundColor: Colors.transparent,
                    minHeight: 8,
                    value: (state?.timeLeft ?? 0) / 60.0,
                  ),
                  const SizedBox(height: 16),
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
                                  backgroundColor: Colors.white,
                                  child: FittedBox(
                                      child: user1?.avatarAddress != null
                                          ? Image.network(
                                              user1!.avatarAddress!,
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
                                    "${state?.user1Score ?? 0}",
                                    textColor: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppText("${user1?.name ?? user1?.userId}"),
                        ],
                      )),
                      AppText.title("${state?.timeLeft ?? 0}"),
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
                                  backgroundColor: Colors.white,
                                  child: FittedBox(
                                      child: user2?.avatarAddress != null
                                          ? Image.network(
                                              user2!.avatarAddress!,
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
                                    "${state?.user2Score ?? 0}",
                                    textColor: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppText("${user2?.name ?? user2?.userId}"),
                        ],
                      )),
                    ],
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (_, constraints) {
                      var index = (isUser1 == true ? state?.user1Index : state?.user2Index) ?? 0;
                      var correctWords = isUser1 == true ? state?.user1CorrectWords : state?.user2CorrectWords;
                      var wrongWords = isUser1 == true ? state?.user1WrongWords : state?.user2WrongWords;
                      var oppIndex = (isUser1 == false ? state?.user1Index : state?.user2Index) ?? 0;
                      var oppCorrectWords = isUser1 == false ? state?.user1CorrectWords : state?.user2CorrectWords;
                      var oppWrongWords = isUser1 == false ? state?.user1WrongWords : state?.user2WrongWords;
                      return Center(
                        child: Container(
                          width: min(constraints.maxWidth, constraints.maxHeight),
                          height: min(constraints.maxHeight, constraints.maxWidth),
                          child: Column(
                            children: [
                              const AppText("کلمات زیر را با نهایت سرعت تایپ کنید:",
                                  textColor: AppColors.primaryDark),
                              Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset.zero,
                                        color: AppColors.shadow,
                                        blurRadius: 12,
                                        spreadRadius: 4,
                                      )
                                    ]),
                                child: Wrap(children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        for (int i = index - 6 > 0 ? index - 6 : 0; i < words!.length; i++)
                                          if (i == index)
                                            for (int i2 = 0; i2 < words![i].length; i2++)
                                              if (i2 < controller.text.length &&
                                                  words![i][i2] == controller.text[i2])
                                                TextSpan(
                                                  style: const TextStyle(
                                                    color: AppColors.textSuccess,
                                                    fontSize: AppTextSizes.large,
                                                    fontFamily: "Tanha",
                                                  ),
                                                  text: "${words?[i][i2]}${words?[i].length == i2 + 1 ? " " : ""}",
                                                )
                                              else if (i2 < controller.text.length &&
                                                  words![i][i2] != controller.text[i2])
                                                TextSpan(
                                                  style: const TextStyle(
                                                    color: AppColors.textFailed,
                                                    fontSize: AppTextSizes.large,
                                                    fontFamily: "Tanha",
                                                  ),
                                                  text: "${words?[i][i2]}${words?[i].length == i2 + 1 ? " " : ""}",
                                                )
                                              else
                                                TextSpan(
                                                  style: const TextStyle(
                                                    color: AppColors.textSecondary,
                                                    fontSize: AppTextSizes.large,
                                                    fontFamily: "Tanha",
                                                  ),
                                                  text: "${words?[i][i2]}${words?[i].length == i2 + 1 ? " " : ""}",
                                                )
                                          else
                                            TextSpan(
                                              style: TextStyle(
                                                color: correctWords?.contains(i) ?? false
                                                    ? AppColors.textSuccess
                                                    : wrongWords?.contains(i) ?? false
                                                        ? AppColors.textFailed
                                                        : AppColors.textSecondary,
                                                fontSize: AppTextSizes.large,
                                                fontFamily: "Tanha",
                                              ),
                                              text: "${words?[i] ?? ""} ",
                                            ),
                                      ],
                                    ),
                                    maxLines: 3,
                                  ),
                                ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: AppInput(
                                  icon: const Icon(MaterialCommunityIcons.keyboard_variant),
                                  controller: controller,
                                ),
                              ),
                              const AppText.secondary("وضعیت حریف شما:"),
                              Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.8),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        offset: Offset.zero,
                                        color: AppColors.shadow,
                                        blurRadius: 12,
                                        spreadRadius: 4,
                                      )
                                    ]),
                                child: Wrap(children: [
                                  Opacity(
                                    opacity: .7,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          for (int i = oppIndex - 3 > 0 ? oppIndex - 3 : 0; i < words!.length; i++)
                                            TextSpan(
                                              style: TextStyle(
                                                color: oppCorrectWords?.contains(i) ?? false
                                                    ? AppColors.textSuccess
                                                    : oppWrongWords?.contains(i) ?? false
                                                        ? AppColors.textFailed
                                                        : AppColors.textSecondary,
                                                fontSize: 14,
                                                fontFamily: "Tanha",
                                              ),
                                              text: "${words?[i] ?? ""} ",
                                            ),
                                        ],
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              )
            else if (gameState == GameState.searching)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  const SearchIcon(),
                  const AppText.secondary(
                    "در حال جستجوی بازیکن...",
                    textSize: AppTextSizes.normal,
                  ),
                  AppText.secondary(
                    "تعداد بازیکنان آنلاین در این بازی: $onlineCount",
                    textColor: AppColors.textSuccess,
                  ),
                ],
              )
            else if (gameState == GameState.error)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  const Icon(Icons.error),
                  const AppText.secondary(
                    "متاسفانه خطایی رخ داده است.",
                    textSize: AppTextSizes.normal,
                  ),
                  AppText.secondary(
                    "$error",
                    textColor: AppColors.textSuccess,
                  ),
                  AppButton(
                    text: "خروج",
                    onTap: () => Navigator.pop(context),
                  )
                ],
              )
            else if (gameState == GameState.endOfGame)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isUser1 == true && (state?.user1Score ?? 0) > (state?.user2Score ?? 0))
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AppText.title("شما برنده شدید!", textColor: AppColors.textSuccess),
                    ),
                  if (isUser1 == true && (state?.user1Score ?? 0) < (state?.user2Score ?? 0))
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AppText.title("${user2?.name ?? user2?.userId} برنده شد!",
                          textColor: AppColors.textFailed),
                    ),
                  if (isUser1 != true && (state?.user2Score ?? 0) > (state?.user1Score ?? 0))
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AppText.title("شما برنده شدید!", textColor: AppColors.textSuccess),
                    ),
                  if (isUser1 != true && (state?.user2Score ?? 0) < (state?.user1Score ?? 0))
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AppText.title("${user1?.name ?? user2?.userId} برنده شد!",
                          textColor: AppColors.textFailed),
                    ),
                  if ((state?.user1Score ?? 0) == (state?.user2Score ?? 0))
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:
                          AppText.title("بازی با نتیجه مساوی به اتمام رسید!", textColor: AppColors.textSecondary),
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
                                  backgroundColor: Colors.white,
                                  child: FittedBox(
                                      child: user1?.avatarAddress != null
                                          ? Image.network(
                                              user1!.avatarAddress!,
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
                                    "${state?.user1Score ?? 0}",
                                    textColor: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppText("${user1?.name ?? user1?.userId}"),
                        ],
                      )),
                      AppText.title("${state?.user1Score} - ${state?.user2Score}"),
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
                                  backgroundColor: Colors.white,
                                  child: FittedBox(
                                      child: user2?.avatarAddress != null
                                          ? Image.network(
                                              user2!.avatarAddress!,
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
                                    "${state?.user2Score ?? 0}",
                                    textColor: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          AppText("${user2?.name ?? user2?.userId}"),
                        ],
                      )),
                    ],
                  ),
                  AppButton(
                    text: "بازگشت به صفحه اصلی",
                    onTap: () => Navigator.pop(context),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
