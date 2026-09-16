import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

/// タイトルスライド。登壇ごとにタイトル・サブタイトル・イベント名を書き換える。
class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(route: '/title'),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deckText,
                  height: 1.3,
                ),
                children: [
                  TextSpan(text: 'ここに'),
                  TextSpan(
                    text: 'タイトル',
                    style: TextStyle(color: AppColors.blue),
                  ),
                  TextSpan(text: 'を書く'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'サブタイトル / ひとこと',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'イベント名 2026',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withValues(alpha: 0.38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
