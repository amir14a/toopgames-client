import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:toopgames_client/util/request_state.dart';
import 'package:toopgames_client/view/widgets/texts.dart';
import 'package:url_launcher/url_launcher.dart';

extension ColorFunc on Color {
  MaterialColor toMaterial() => MaterialColor(value, {
        50: this,
        100: this,
        200: this,
        300: this,
        400: this,
        500: this,
        600: this,
        700: this,
        800: this,
        900: this,
      });
}

extension StringFuncs on String {
  String fixWeb(bool web) => web ? replaceFirst('assets/', '').replaceFirst('assets\\', '') : this;

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  void launchURL() async => await canLaunch(this)
      ? await launch(
          this,
          forceSafariVC: true,
          webOnlyWindowName: '_self',
        )
      : throw 'Could not launch $this';
}

extension ContextFuncs on BuildContext {
  void showSnackBar(String? text) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (text != null) {
        final _pixelRatio = WidgetsBinding.instance?.window.devicePixelRatio ?? 1;
        final width = (WidgetsBinding.instance?.window.physicalSize.width ?? 0) * 1 / _pixelRatio;
        final height = (WidgetsBinding.instance?.window.physicalSize.height ?? 0) * 1 / _pixelRatio;
        final size = width > height * .75 ? height * .75 : width;
        ScaffoldMessenger.of(this).showSnackBar(SnackBar(
            width: size == 0 ? null : size - 16,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              children: [
                Flexible(
                  child: AppText(
                    text,
                    textColor: Colors.white,
                  ),
                )
              ],
            )));
      }
    });
  }
}

extension DateFuncs on DateTime {
  String formatJustDate() {
    return "$year-$month-$day";
  }

  String formatDateAndTime() {
    return "$year-$month-$day $hour:$minute";
  }
}

extension RS on ValueNotifier<RequestState> {
  bool isSending() => value == RequestState.SENDING;

  bool isSuccess() => value == RequestState.SUCCESS;

  bool isFailed() => value == RequestState.FAILED || value == RequestState.FAILED_NO_NETWORK;
}

extension NullableStringFuncs on String? {
  DateTime? toDate() {
    var formats = ["yyyy-MM-dd'T'HH:mm:ss.SS", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss.SSS"];
    for (var element in formats) {
      try {
        return intl.DateFormat(element).parse(this ?? "");
      } catch (e) {
        //no need
      }
    }
  }
}
