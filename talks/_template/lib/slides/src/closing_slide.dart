import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

/// クロージングスライド。
class ClosingSlide extends FlutterDeckSlideWidget {
  const ClosingSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(route: '/closing'),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const Center(
        child: Text(
          'ありがとうございました！',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: AppColors.deckText,
          ),
        ),
      ),
    );
  }
}
