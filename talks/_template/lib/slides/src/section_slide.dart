import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

/// 本編用のサンプルスライド。ヘッダー付き + 箇条書きのよくある形。
class SectionSlide extends FlutterDeckSlideWidget {
  const SectionSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(
            route: '/section',
            header: FlutterDeckHeaderConfiguration(title: 'セクションのタイトル'),
          ),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _Bullet('伝えたいこと その 1'),
            SizedBox(height: 24),
            _Bullet('伝えたいこと その 2'),
            SizedBox(height: 24),
            _Bullet('伝えたいこと その 3'),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('・', style: TextStyle(fontSize: 32, color: AppColors.blue)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 32, color: AppColors.deckText),
          ),
        ),
      ],
    );
  }
}
