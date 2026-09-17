import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../design/slide_tokens.dart';

/// タイトルスライドのレイアウト。
///
/// [titleSpans] で一部の語だけ色を変えられる。
class TitleLayout extends StatelessWidget {
  const TitleLayout({
    super.key,
    this.title = '',
    this.titleSpans,
    this.subtitle,
    this.eventName,
  }) : assert(
          title != '' || titleSpans != null,
          'title か titleSpans のどちらかを指定してください',
        );

  /// プレーンなタイトル（[titleSpans] 指定時は無視）。
  final String title;

  /// 装飾付きタイトル。指定するとこちらが優先。
  final List<InlineSpan>? titleSpans;

  final String? subtitle;
  final String? eventName;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: titleSpans != null
                ? TextSpan(style: SlideTextStyles.display, children: titleSpans)
                : TextSpan(text: title, style: SlideTextStyles.display),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: SlideSpacing.lg),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: SlideTextStyles.subtitle.copyWith(
                color: AppColors.deckText.withValues(alpha: 0.75),
                fontWeight: FontWeight.w400,
                fontSize: 40,
              ),
            ),
          ],
          if (eventName != null) ...[
            const SizedBox(height: SlideSpacing.xl),
            Text(
              eventName!,
              style: SlideTextStyles.caption.copyWith(
                color: AppColors.deckText.withValues(alpha: 0.4),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 章扉レイアウト。大きな通し番号とセクションタイトル。
class SectionDividerLayout extends StatelessWidget {
  const SectionDividerLayout({
    super.key,
    required this.title,
    this.label,
    this.subtitle,
    this.accent = AppColors.blue,
  });

  /// セクションタイトル。
  final String title;

  /// 上に小さく載せるラベル（例: `01` / `SECTION 1`）。
  final String? label;

  final String? subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: accent,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: SlideSpacing.md),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SlideDecoration.accentBar(color: accent, width: 12, height: 96),
              const SizedBox(width: SlideSpacing.lg),
              Flexible(child: Text(title, style: SlideTextStyles.headline)),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: SlideSpacing.lg),
            Text(subtitle!, style: SlideTextStyles.caption),
          ],
        ],
      ),
    );
  }
}

/// キメの一言レイアウト。中央に特大メッセージ。
class BigMessageLayout extends StatelessWidget {
  const BigMessageLayout({
    super.key,
    required this.message,
    this.gradient = AppColors.primaryGradient,
    this.useGradient = true,
  });

  final String message;
  final Gradient gradient;

  /// 文字にグラデーションを乗せるか。
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      message,
      textAlign: TextAlign.center,
      style: SlideTextStyles.display.copyWith(fontSize: 96),
    );

    return SlideFrame(
      alignment: Alignment.center,
      child: useGradient
          ? ShaderMask(
              shaderCallback: (bounds) => gradient.createShader(bounds),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: text,
              ),
            )
          : text,
    );
  }
}
