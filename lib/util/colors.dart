import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3F51B5);
  static const Color primaryDark = Color(0xFF303F9F);
  static const Color primaryRipple = Color(0x809FA8DA);
  static const Color primaryHighlight = Color(0x257065E4);
  static const Color secondary = Color(0xFFE91E63);
  static const Color textNormal = Color(0xFF03030A);
  static const Color textSecondary = Color(0xFF515153);
  static const Color shadow = Color(0x40555555);
  static const Color primaryShadow = Color(0x403F51B5);
  static const Color textSuccess = Color(0xFF43A047);
  static const Color textFailed = Color(0xFFA04343);
  static const Color bg = Color(0xFFEEEEEE);
  static const Color timeColor = Color(0xFF64DD17);
  static const Color gold = Color(0xFFC9B037);
  static const Color silver = Color(0xFFB4B4B4);
  static const Color bronze = Color(0xFF6A3805);

  static const List<Color> _cardColors = [
    Color(0xFF5D8CC5),
    Color(0xFF39C8A8),
    Color(0xFFF7B500),
    Color(0xFFDC2E69)
  ];
  static const List<Color> _iconColors = [
    Color(0xFF7065E4),
    Color(0xFFE46594),
    Color(0xFF35AE35),
  ];

  static Color getCardColor(int index) => _cardColors[index % _cardColors.length];

  static Color getIconColor(int index) => _iconColors[index % _iconColors.length];
}
