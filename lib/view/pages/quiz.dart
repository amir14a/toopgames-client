import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toopgames_client/model/game_state.dart';
import 'package:toopgames_client/model/question_model.dart';
import 'package:toopgames_client/model/quiz_state.dart';
import 'package:toopgames_client/model/user_model.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/consts.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/widgets/app_bars.dart';
import 'package:toopgames_client/view/widgets/buttons.dart';
import 'package:toopgames_client/view/widgets/search.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  GameState gameState = GameState.searching;
  String? error;
  int onlineCount = 0;
  QuizState? state;
  UserModel? user1;
  UserModel? user2;
  bool? isUser1;
  int? gameId;
  List<QuestionModel>? questions;
  late WebSocketChannel channel;

  @override
  void initState() {
    channel = WebSocketChannel.connect(Uri.parse(Consts.quizUrl));
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
          user1 = UserModel.fromJson(json["content"]["player1"]);
          user2 = UserModel.fromJson(json["content"]["player2"]);
          questions = QuestionModel.fromList(json["content"]["questions"]);
          isUser1 = json["content"]["is_player1"];
          gameId = json["content"]["game_id"];
          gameState = GameState.duringGame;
        });
      } else if (json["action"] == "update_game") {
        print(json);
        setState(() {
          state = QuizState.fromJson(json["content"]);
          if (state?.endGame == true) {
            gameState = GameState.endOfGame;
          }
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
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  value: (state?.timeLeft ?? 0) / 30.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 5; i++)
                              Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.textSecondary),
                                    color: state?.user1CorrectQuestions?.contains(i) ?? false
                                        ? AppColors.textSuccess
                                        : state?.user1WrongQuestions?.contains(i) ?? false
                                            ? AppColors.textFailed
                                            : Colors.transparent),
                                child: AppText.secondary(
                                  (i + 1).toString(),
                                  textSize: AppTextSizes.verySmall,
                                ),
                              )
                          ],
                        )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 5; i++)
                              Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.textSecondary),
                                    color: state?.user2CorrectQuestions?.contains(i) ?? false
                                        ? AppColors.textSuccess
                                        : state?.user2WrongQuestions?.contains(i) ?? false
                                            ? AppColors.textFailed
                                            : Colors.transparent),
                                child: AppText.secondary(
                                  (i + 1).toString(),
                                  textSize: AppTextSizes.verySmall,
                                ),
                              )
                          ],
                        )
                      ],
                    )),
                  ],
                ),
                Expanded(
                  child: LayoutBuilder(builder: (_, constraints) {
                    var q = questions![state!.index!];
                    int? selectedAnswer = isUser1 == true ? state?.user1Answer : state?.user2Answer;
                    int? oppSelectedAnswer = isUser1 == true ? state?.user2Answer : state?.user1Answer;
                    bool canSendAnswer = isUser1 == true ? state?.user1Answer == 0 : state?.user2Answer == 0;
                    List<String> answerList = [q.answer1!, q.answer2!, q.answer3!, q.answer4!];
                    List<Widget> answerWidgets = [];
                    for (var i = 1; i <= answerList.length; i++) {
                      if (i == selectedAnswer) {
                        answerWidgets.add(Container(
                          margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(offset: Offset(0, 0), color: AppColors.shadow, blurRadius: 12)
                            ],
                            color:
                                (selectedAnswer == q.correctAnswer ? AppColors.textSuccess : AppColors.textFailed)
                                    .withOpacity(.5),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: AppText.secondary(answerList[i - 1])),
                            ],
                          ),
                        ));
                        continue;
                      }
                      answerWidgets.add(Container(
                        margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(offset: Offset(0, 0), color: AppColors.shadow, blurRadius: 12)
                          ],
                          color: state?.showResult == true && q.correctAnswer == i
                              ? AppColors.textSuccess.withOpacity(.5)
                              : Colors.white,
                        ),
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: !canSendAnswer
                                    ? null
                                    : () {
                                        channel.sink.add(jsonEncode({
                                          "action": "select_answer",
                                          "content": {
                                            "game_id": gameId,
                                            "answer": i,
                                          }
                                        }));
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: AppText.secondary(answerList[i - 1])),
                                      if (state?.showResult == true && oppSelectedAnswer == i)
                                        AppText.secondary(
                                          "پاسخ حریف",
                                          textSize: AppTextSizes.verySmall,
                                        )
                                    ],
                                  ),
                                ))),
                      ));
                    }
                    return Center(
                      child: Container(
                        width: min(constraints.maxWidth, constraints.maxHeight * 1.4),
                        height: min(constraints.maxHeight, constraints.maxWidth / 1.4),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(0, 0), color: AppColors.primaryShadow, blurRadius: 12)
                                    ],
                                    gradient:
                                        const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark])),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: AppText(
                                      q.question,
                                      textColor: Colors.white,
                                    )),
                                  ],
                                )),
                            for (var w in answerWidgets) w
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
                    child: AppText.title("بازی با نتیجه مساوی به اتمام رسید!", textColor: AppColors.textSecondary),
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
    );
  }
}
