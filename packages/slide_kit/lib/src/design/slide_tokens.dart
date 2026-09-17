import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// レイアウト共通の余白（1920x1080 基準）。
class SlideSpacing {
  const SlideSpacing._();

  /// スライド左右の標準パディング。
  static const double horizontal = 120;

  /// スライド上下の標準パディング。
  static const double vertical = 96;

  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 40;
  static const double xl = 64;
}

/// レイアウト共通のテキストスタイル（1920x1080 基準）。
class SlideTextStyles {
  const SlideTextStyles._();

  /// タイトルスライド用の特大見出し。
  static const TextStyle display = TextStyle(
    fontSize: 84,
    fontWeight: FontWeight.bold,
    color: AppColors.deckText,
    height: 1.15,
  );

  /// 章扉・キメ用の大見出し。
  static const TextStyle headline = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.bold,
    color: AppColors.deckText,
    height: 1.2,
  );

  /// スライド上部の見出し。
  static const TextStyle title = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: AppColors.deckText,
    height: 1.25,
  );

  /// 小見出し。
  static const TextStyle subtitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.deckText,
  );

  /// 本文。
  static const TextStyle body = TextStyle(
    fontSize: 32,
    color: AppColors.deckText,
    height: 1.4,
  );

  /// 補足・キャプション。
  static TextStyle caption = TextStyle(
    fontSize: 24,
    color: AppColors.deckText.withValues(alpha: 0.6),
    height: 1.4,
  );

  /// コード表示用の等幅スタイル。
  static const TextStyle code = TextStyle(
    fontSize: 28,
    fontFamily: 'monospace',
    color: AppColors.deckText,
    height: 1.5,
  );
}

/// レイアウトで使う装飾ヘルパー。
class SlideDecoration {
  const SlideDecoration._();

  /// アクセントに使う縦バー。
  static Widget accentBar({
    Color color = AppColors.blue,
    double width = 8,
    double height = 56,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width),
      ),
    );
  }

  /// カード状のサーフェス装飾。
  static BoxDecoration card({Color? accent}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: (accent ?? Colors.white).withValues(alpha: accent != null ? 0.5 : 0.08),
        width: accent != null ? 2 : 1,
      ),
    );
  }
}

/// レイアウトの中身を標準パディングで包む枠。
///
/// 各レイアウトウィジェットの土台として使う。
class SlideFrame extends StatelessWidget {
  const SlideFrame({
    super.key,
    required this.child,
    this.padding,
    this.alignment = Alignment.topLeft,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: SlideSpacing.horizontal,
            vertical: SlideSpacing.vertical,
          ),
      child: Align(alignment: alignment, child: child),
    );
  }
}

/// スライド上部の見出し（アクセントバー付き）。
class SlideHeading extends StatelessWidget {
  const SlideHeading(
    this.title, {
    super.key,
    this.accent = AppColors.blue,
    this.trailing,
  });

  final String title;
  final Color accent;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SlideDecoration.accentBar(color: accent),
        const SizedBox(width: SlideSpacing.md),
        Expanded(child: Text(title, style: SlideTextStyles.title)),
        if (trailing != null) trailing!,
      ],
    );
  }
}
