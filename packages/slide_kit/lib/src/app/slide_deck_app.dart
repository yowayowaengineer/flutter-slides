import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../footer/walking_footer.dart';
import '../theme/slide_theme.dart';

/// 各登壇アプリのルートウィジェット。
///
/// flutter_deck の [FlutterDeckApp] を共通の設定（テーマ・歩くフッター・
/// キーボードショートカット・デザインサイズ 1920x1080）でラップする。
/// 登壇側は基本これに [slides] を渡すだけでよい。
///
/// ```dart
/// void main() => runApp(SlideDeckApp(slides: slides));
/// ```
class SlideDeckApp extends StatelessWidget {
  const SlideDeckApp({
    super.key,
    required this.slides,
    this.lightTheme,
    this.darkTheme,
    this.footer = const WalkingFooter(),
    this.designSize = const Size(1920, 1080),
    this.showSlideNumbers = true,
    this.transition = const FlutterDeckTransition.fade(),
  });

  /// 表示するスライド一覧。
  final List<FlutterDeckSlideWidget> slides;

  /// ライトテーマ（省略時は [SlideTheme.light]）。
  final FlutterDeckThemeData? lightTheme;

  /// ダークテーマ（省略時は [SlideTheme.dark]）。
  final FlutterDeckThemeData? darkTheme;

  /// フッターウィジェット。既定は [WalkingFooter]。`null` で無効化。
  final Widget? footer;

  /// ScreenUtil の基準デザインサイズ。
  final Size designSize;

  /// フッターにスライド番号を出すか。
  final bool showSlideNumbers;

  /// スライド遷移アニメーション。
  final FlutterDeckTransition transition;

  @override
  Widget build(BuildContext context) {
    final light = lightTheme ?? SlideTheme.light();
    final dark = darkTheme ?? SlideTheme.dark();

    return ScreenUtilInit(
      designSize: designSize,
      builder: (context, child) => FlutterDeckApp(
        slides: slides,
        lightTheme: light,
        darkTheme: dark,
        configuration: FlutterDeckConfiguration(
          transition: transition,
          controls: const FlutterDeckControlsConfiguration(
            presenterToolbarVisible: true,
            gestures: FlutterDeckGesturesConfiguration.mobileOnly(),
            shortcuts: FlutterDeckShortcutsConfiguration(
              enabled: true,
              nextSlide: {SingleActivator(LogicalKeyboardKey.arrowRight)},
              previousSlide: {SingleActivator(LogicalKeyboardKey.arrowLeft)},
              toggleMarker: {
                SingleActivator(
                  LogicalKeyboardKey.keyM,
                  control: true,
                  meta: true,
                ),
              },
              toggleNavigationDrawer: {
                SingleActivator(
                  LogicalKeyboardKey.period,
                  control: true,
                  meta: true,
                ),
              },
            ),
          ),
          footer: FlutterDeckFooterConfiguration(
            showSlideNumbers: showSlideNumbers,
            widget: footer ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
