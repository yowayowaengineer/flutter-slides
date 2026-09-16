import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import 'app_colors.dart';

/// [AppColors] を元に flutter_deck 用のテーマを組み立てるヘルパー。
///
/// 既定では light / dark どちらもダーク基調（[AppColors.deckBackground]）。
/// 登壇ごとに色を変えたいときは [seedColor] や [background] を渡す。
class SlideTheme {
  const SlideTheme._();

  static FlutterDeckThemeData light({
    Color seedColor = AppColors.blue,
    Color background = AppColors.deckBackground,
    Color text = AppColors.deckText,
  }) =>
      _build(Brightness.light, seedColor, background, text);

  static FlutterDeckThemeData dark({
    Color seedColor = AppColors.blue,
    Color background = AppColors.deckBackground,
    Color text = AppColors.deckText,
  }) =>
      _build(Brightness.dark, seedColor, background, text);

  static FlutterDeckThemeData _build(
    Brightness brightness,
    Color seedColor,
    Color background,
    Color text,
  ) {
    return FlutterDeckThemeData(
      brightness: brightness,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
          surface: background,
          onSurface: text,
        ),
      ),
      textTheme: const FlutterDeckTextTheme().apply(color: text),
    );
  }
}
