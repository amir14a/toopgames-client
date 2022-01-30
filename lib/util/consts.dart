import 'dart:io';

import 'package:flutter/foundation.dart';

class Consts {
  static const double defaultCardRadius = 16;
  static const String userTag = "USER_OBJECT";
  static const String lockSettings = "LOCK_SETTINGS";
  static const String pendingPaymentTag = "IS_PENDING_PAYMENT";
  static bool isDemo = false;
  static final bool usePngInsSvg = (kIsWeb) || (!kIsWeb && Platform.isAndroid);
  static const String httpUrl = "http://amir-abbas.ir:9454";
  static const String memoryCardUrl = "ws://amir-abbas.ir:9455";
  static const String typingTestUrl = "ws://amir-abbas.ir:9456";
  static const String quizUrl = "ws://amir-abbas.ir:9457";
}
