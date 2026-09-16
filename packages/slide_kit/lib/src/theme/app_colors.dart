import 'package:flutter/material.dart';

/// 登壇資料共通のカラーパレット。
///
/// 登壇ごとに差し替えたい場合は [SlideDeckApp] にテーマを渡して上書きする。
class AppColors {
  const AppColors._();

  static const Color deckBackground = Color(0xFF0D1117);
  static const Color deckText = Color(0xFFFFFFFF);

  static const Color blue = Color(0xFF5EC9F7);
  static const Color pink = Color(0xFFEF97B0);
  static const Color green = Color(0xFF4CAF50);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pink, blue],
  );
}
