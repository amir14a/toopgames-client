import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toopgames_client/model/game_state.dart';
import 'package:toopgames_client/model/memory_card_state.dart';
import 'package:toopgames_client/model/user_model.dart';
import 'package:toopgames_client/util/colors.dart';
import 'package:toopgames_client/util/consts.dart';
import 'package:toopgames_client/util/extension_funs.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/view/widgets/app_bars.dart';
import 'package:toopgames_client/view/widgets/buttons.dart';
import 'package:toopgames_client/view/widgets/search.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MemoryCardPage extends StatefulWidget {
  const MemoryCardPage({Key? key}) : super(key: key);

  @override
  _MemoryCardPageState createState() => _MemoryCardPageState();
}

class _MemoryCardPageState extends State<MemoryCardPage> {
  GameState gameState = GameState.searching;
  String? error;
  int onlineCount = 0;
  MemoryCardState? state;
  UserModel? user1;
  UserModel? user2;
  bool? isUser1;
  int? gameId;
  List<String>? cards;
  late WebSocketChannel channel;

  @override
  void initState() {
    channel = WebSocketChannel.connect(Uri.parse(Consts.memoryCardUrl));
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
          cards = json["content"]["cards"].cast<String>();
          isUser1 = json["content"]["is_player1"];
          gameId = json["content"]["game_id"];
        });
      } else if (json["action"] == "update_game") {
        setState(() {
          state = MemoryCardState.fromJson(json["content"]);
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
    channel.sink.close(goingAway);
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
                            if (state?.user1Turn == true)
                              SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: CircularProgressIndicator(
                                    value: (state?.timeLeft ?? 0) / 30.0,
                                    color: AppColors.timeColor,
                                  )),
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
                            if (state?.user1Turn == false)
                              SizedBox(
                                  width: 72,
                                  height: 72,
                                  child: CircularProgressIndicator(
                                    value: (state?.timeLeft ?? 0) / 30.0,
                                    color: AppColors.timeColor,
                                  )),
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
                    return Center(
                      child: Container(
                        width: min(constraints.maxWidth, constraints.maxHeight * 1.4),
                        height: min(constraints.maxHeight, constraints.maxWidth / 1.4),
                        child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              mainAxisExtent: min(constraints.maxHeight, constraints.maxWidth / 1.4) / 3,
                            ),
                            itemCount: 18,
                            itemBuilder: (context, index) => GameCard(
                                  visible: state?.visibleCards?.contains(index),
                                  hidden: state?.hiddenCards?.contains(index),
                                  imgName: cards?[index],
                                  selectable: state?.user1Turn == isUser1,
                                  onSelect: () {
                                    channel.sink.add(jsonEncode({
                                      "action": "select_card",
                                      "content": {
                                        "game_id": gameId,
                                        "selected_index": index,
                                      }
                                    }));
                                  },
                                  onNotSelectable: () {
                                    context.showSnackBar("نوبت شما نیست");
                                  },
                                )),
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

class GameCard extends StatefulWidget {
  final bool? visible;
  final String? imgName;
  final bool? selectable;
  final bool? hidden;
  final void Function()? onSelect;
  final void Function()? onNotSelectable;

  const GameCard(
      {Key? key, this.visible, this.imgName, this.selectable, this.onSelect, this.hidden, this.onNotSelectable})
      : super(key: key);

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  late Timer _timer;

  @override
  void initState() {
    // _state=false;
    _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (widget.selectable == true) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hidden == true) return const SizedBox();
    bool _state = DateTime.now().second % 2 == 0;
    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.all(6),
      duration: const Duration(milliseconds: 600),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
        if (widget.selectable == true)
          BoxShadow(blurRadius: _state ? 1 : 5, color: AppColors.primaryShadow, spreadRadius: _state ? 0 : 4)
        else
          const BoxShadow(blurRadius: 8, color: AppColors.shadow)
      ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (widget.selectable == true ? widget.onSelect : widget.onNotSelectable),
          child: SizedBox.expand(
            child: ((widget.imgName != null && widget.visible == true)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/imgs/${widget.imgName}.webp",
                      fit: BoxFit.contain,
                    ),
                  )
                : null),
          ),
        ),
      ),
    );
  }
}
