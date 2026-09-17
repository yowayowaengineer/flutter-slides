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

  /// 余白ゼロ・スライド全面に敷くスライドに変換する。
  ///
  /// [asSlide] が使う flutter_deck の `builder` は
  /// `FlutterDeckLayout.slidePadding`（16px）で包まれ、さらにヘッダー／
  /// フッターに挟まれた `Column` の中に入るため、画面の隅までは届かない。
  /// こちらは `backgroundBuilder` に渡すので、`BoxConstraints.expand()` で
  /// スライド全面に広がる。
  ///
  /// フッター（歩くキャラ・ページ番号）は前面に残るので、下端に文字を置く
  /// ウィジェットを渡すときは重なりに注意する。
  ///
  /// ```dart
  /// FullBleedImageLayout(image: ...).asFullBleedSlide('/shot')
  /// ```
  FlutterDeckSlideWidget asFullBleedSlide(String route, {String? title}) {
    return _FullBleedSlide(route: route, title: title, child: this);
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

class _FullBleedSlide extends FlutterDeckSlideWidget {
  _FullBleedSlide({required String route, required this.child, this.title})
      : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route,
            title: title,
          ),
        );

  final Widget child;
  final String? title;

  @override
  FlutterDeckSlide build(BuildContext context) {
    // 背景レイヤーに置くことで、パディングもヘッダー/フッターの Column も
    // 通らずにスライド全面へ広がる。
    return FlutterDeckSlide.blank(
      backgroundBuilder: (context) => child,
      builder: (context) => const SizedBox.shrink(),
    );
  }
}
