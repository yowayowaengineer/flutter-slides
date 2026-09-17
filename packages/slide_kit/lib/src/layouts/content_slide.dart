import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

/// 任意の [Widget] を、共通フッター（歩くキャラ・ページ番号）付きの
/// スライドに変換する。
///
/// レイアウト部品をそのままスライドにできる:
/// ```dart
/// BulletLayout(title: '...', bullets: [...]).asSlide('/intro')
/// ```
extension SlideContentX on Widget {
  FlutterDeckSlideWidget asSlide(
    String route, {
    String? title,
    Color? background,
  }) {
    return _ContentSlide(
      route: route,
      title: title,
      background: background,
      child: this,
    );
  }
}

class _ContentSlide extends FlutterDeckSlideWidget {
  _ContentSlide({
    required String route,
    required this.child,
    this.title,
    this.background,
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route,
            title: title,
          ),
        );

  final Widget child;
  final String? title;
  final Color? background;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      backgroundBuilder: background != null
          ? (context) => ColoredBox(color: background!)
          : null,
      builder: (context) => child,
    );
  }
}
