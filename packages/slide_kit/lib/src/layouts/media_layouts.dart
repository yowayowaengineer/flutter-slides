import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../design/slide_tokens.dart';

/// 引用レイアウト。
class QuoteLayout extends StatelessWidget {
  const QuoteLayout({
    super.key,
    required this.quote,
    this.attribution,
    this.accent = AppColors.blue,
  });

  final String quote;
  final String? attribution;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"',
            style: TextStyle(
              fontSize: 160,
              height: 0.8,
              fontWeight: FontWeight.bold,
              color: accent.withValues(alpha: 0.6),
            ),
          ),
          Text(
            quote,
            style: SlideTextStyles.headline.copyWith(
              fontSize: 52,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          if (attribution != null) ...[
            const SizedBox(height: SlideSpacing.lg),
            Row(
              children: [
                SlideDecoration.accentBar(color: accent, height: 4, width: 48),
                const SizedBox(width: SlideSpacing.md),
                Text(
                  attribution!,
                  style: SlideTextStyles.caption.copyWith(fontSize: 28),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// コード表示レイアウト。ダークカード＋等幅フォント。
///
/// シンタックスハイライトは行わない（プレーン表示）。ハイライトが必要なら
/// flutter_deck の `FlutterDeckCodeHighlight` を各登壇で使う。
class CodeLayout extends StatelessWidget {
  const CodeLayout({
    super.key,
    required this.code,
    this.title,
    this.filename,
    this.accent = AppColors.blue,
  });

  final String code;
  final String? title;

  /// カード上部に表示するファイル名タブ。
  final String? filename;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            SlideHeading(title!, accent: accent),
            const SizedBox(height: SlideSpacing.lg),
          ],
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WindowBar(filename: filename),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(SlideSpacing.lg),
                      child: SelectableText(code, style: SlideTextStyles.code),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowBar extends StatelessWidget {
  const _WindowBar({this.filename});

  final String? filename;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SlideSpacing.md, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          _dot(const Color(0xFFFF5F56)),
          const SizedBox(width: 8),
          _dot(const Color(0xFFFFBD2E)),
          const SizedBox(width: 8),
          _dot(const Color(0xFF27C93F)),
          if (filename != null) ...[
            const SizedBox(width: SlideSpacing.md),
            Text(
              filename!,
              style: SlideTextStyles.caption.copyWith(fontSize: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _dot(Color color) =>
      Container(width: 16, height: 16, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

/// 画像＋キャプションレイアウト。
class CaptionedImageLayout extends StatelessWidget {
  const CaptionedImageLayout({
    super.key,
    required this.image,
    this.title,
    this.caption,
    this.accent = AppColors.blue,
    this.fit = BoxFit.contain,
  });

  final ImageProvider image;
  final String? title;
  final String? caption;
  final Color accent;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            SlideHeading(title!, accent: accent),
            const SizedBox(height: SlideSpacing.lg),
          ],
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(image: image, fit: fit, width: double.infinity),
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: SlideSpacing.md),
            Center(child: Text(caption!, style: SlideTextStyles.caption)),
          ],
        ],
      ),
    );
  }
}
