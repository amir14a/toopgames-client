import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toopgames_client/util/colors.dart';

class EmptyAppBar extends AppBar {
  final Color? statusBarColor;

  EmptyAppBar({Key? key, this.statusBarColor = AppColors.primary})
      : super(
            key: key,
            toolbarHeight: 0,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: statusBarColor));
}
