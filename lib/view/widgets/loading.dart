import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:toopgames_client/util/colors.dart';

class AppLoading extends StatefulWidget {
  final double size;
  final Color? color;
  final EdgeInsets? padding;

  const AppLoading({Key? key, this.size = 48, this.color, this.padding}) : super(key: key);

  @override
  _AppLoadingState createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double size = widget.size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(4),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
          alignment: Alignment.center,
        ),
        child: Center(
          child: SizedBox(
            width: size,
            height: size,
            child: FittedBox(
              child: Icon(
                FontAwesome.soccer_ball_o,
                color: widget.color ?? AppColors.primaryDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
