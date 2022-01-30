import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toopgames_client/util/colors.dart';

class SearchIcon extends StatefulWidget {
  final double size;

  const SearchIcon({Key? key, this.size = 180}) : super(key: key);

  @override
  _SearchIconState createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double size = widget.size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation = Tween(begin: 0.0, end: 360.0).animate(_controller);
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
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              var r = size / 2 - size / 3;
              return Positioned(
                top: r + r * sin(_animation.value * pi / 180),
                left: r + r * cos(_animation.value * pi / 180),
                child: Icon(
                  Icons.search,
                  color: AppColors.primaryDark,
                  size: size / 1.5,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
