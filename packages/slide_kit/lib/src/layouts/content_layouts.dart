import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../design/slide_tokens.dart';

/// 箇条書きの 1 項目。
class Bullet {
  const Bullet(
    this.text, {
    this.emphasis = false,
    this.color,
    this.children = const [],
  });

  final String text;

  /// 強調（太字＋アクセント色）。
  final bool emphasis;

  /// 個別の色指定。
  final Color? color;

  /// ネストする子項目。
  final List<Bullet> children;
}

/// 見出し＋箇条書きの、最も使うレイアウト。
class BulletLayout extends StatelessWidget {
  const BulletLayout({
    super.key,
    required this.bullets,
    this.title,
    this.accent = AppColors.blue,
  });

  final String? title;
  final List<Bullet> bullets;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            SlideHeading(title!, accent: accent),
            const SizedBox(height: SlideSpacing.xl),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: title != null
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final bullet in bullets) ...[
                  _BulletRow(bullet: bullet, accent: accent),
                  const SizedBox(height: SlideSpacing.lg),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow(
      {required this.bullet, required this.accent, this.depth = 0});

  final Bullet bullet;
  final Color accent;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final isChild = depth > 0;
    final color =
        bullet.color ?? (bullet.emphasis ? accent : AppColors.deckText);

    return Padding(
      padding: EdgeInsets.only(left: depth * 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: isChild ? 14 : 16),
                child: Container(
                  width: isChild ? 10 : 14,
                  height: isChild ? 10 : 14,
                  decoration: BoxDecoration(
                    color: isChild ? accent.withValues(alpha: 0.6) : accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: SlideSpacing.md),
              Expanded(
                // バッククォートで囲んだ部分はコードチップになる。
                child: InlineCodeText(
                  bullet.text,
                  codeColor: accent,
                  style: SlideTextStyles.body.copyWith(
                    fontSize: isChild ? 28 : 32,
                    fontWeight:
                        bullet.emphasis ? FontWeight.bold : FontWeight.normal,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          for (final child in bullet.children) ...[
            const SizedBox(height: SlideSpacing.md),
            _BulletRow(bullet: child, accent: accent, depth: depth + 1),
          ],
        ],
      ),
    );
  }
}

/// アジェンダ（番号付き）。[activeIndex] を指定すると現在地を強調。
class AgendaLayout extends StatelessWidget {
  const AgendaLayout({
    super.key,
    required this.items,
    this.title = 'Agenda',
    this.activeIndex,
    this.accent = AppColors.blue,
  });

  final String title;
  final List<String> items;
  final int? activeIndex;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideHeading(title, accent: accent),
          const SizedBox(height: SlideSpacing.xl),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _AgendaRow(
                    index: i + 1,
                    text: items[i],
                    accent: accent,
                    active: activeIndex == null || activeIndex == i,
                  ),
                  if (i != items.length - 1)
                    const SizedBox(height: SlideSpacing.lg),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaRow extends StatelessWidget {
  const _AgendaRow({
    required this.index,
    required this.text,
    required this.accent,
    required this.active,
  });

  final int index;
  final String text;
  final Color accent;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final opacity = active ? 1.0 : 0.35;
    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? accent : Colors.transparent,
              border: Border.all(color: accent, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: active ? AppColors.deckBackground : accent,
              ),
            ),
          ),
          const SizedBox(width: SlideSpacing.lg),
          Expanded(
            child: Text(
              text,
              style: SlideTextStyles.subtitle
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2 カラムレイアウト。任意の左右ウィジェットを並べる。
class TwoColumnLayout extends StatelessWidget {
  const TwoColumnLayout({
    super.key,
    required this.left,
    required this.right,
    this.title,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.accent = AppColors.blue,
    this.padding,
  });

  final String? title;
  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final Color accent;

  /// フレームの余白（省略時は [SlideFrame] の既定）。縦長画像を大きく見せたい
  /// ときは上下の余白を詰める。
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            SlideHeading(title!, accent: accent),
            const SizedBox(height: SlideSpacing.xl),
          ],
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: leftFlex, child: left),
                const SizedBox(width: SlideSpacing.xl),
                Expanded(flex: rightFlex, child: right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 比較（A vs B / Before-After / メリデメ）レイアウト。
class ComparisonLayout extends StatelessWidget {
  const ComparisonLayout({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.leftItems,
    required this.rightItems,
    this.title,
    this.leftColor = AppColors.pink,
    this.rightColor = AppColors.blue,
  });

  final String? title;
  final String leftTitle;
  final String rightTitle;
  final List<String> leftItems;
  final List<String> rightItems;
  final Color leftColor;
  final Color rightColor;

  @override
  Widget build(BuildContext context) {
    return TwoColumnLayout(
      title: title,
      left: _ComparisonCard(
        heading: leftTitle,
        items: leftItems,
        color: leftColor,
      ),
      right: _ComparisonCard(
        heading: rightTitle,
        items: rightItems,
        color: rightColor,
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.heading,
    required this.items,
    required this.color,
  });

  final String heading;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(SlideSpacing.lg),
      decoration: SlideDecoration.card(accent: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style:
                SlideTextStyles.subtitle.copyWith(color: color, fontSize: 36),
          ),
          const SizedBox(height: SlideSpacing.lg),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(Icons.circle, size: 12, color: color),
                ),
                const SizedBox(width: SlideSpacing.md),
                Expanded(
                  child: Text(item,
                      style: SlideTextStyles.body.copyWith(fontSize: 28)),
                ),
              ],
            ),
            const SizedBox(height: SlideSpacing.md),
          ],
        ],
      ),
    );
  }
}

/// ポイントを並べるカードグリッド。
class PointCard {
  const PointCard({
    required this.title,
    this.description,
    this.emoji,
    this.color = AppColors.blue,
  });

  final String title;
  final String? description;
  final String? emoji;
  final Color color;
}

/// [PointCard] を横並び（自動で折り返し）に配置するレイアウト。
class CardsLayout extends StatelessWidget {
  const CardsLayout({
    super.key,
    required this.cards,
    this.title,
    this.accent = AppColors.blue,
  });

  final String? title;
  final List<PointCard> cards;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SlideFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            SlideHeading(title!, accent: accent),
            const SizedBox(height: SlideSpacing.xl),
          ],
          Expanded(
            child: Center(
              child: Wrap(
                spacing: SlideSpacing.lg,
                runSpacing: SlideSpacing.lg,
                alignment: WrapAlignment.center,
                children: [
                  for (final card in cards) _PointCardTile(card: card)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointCardTile extends StatelessWidget {
  const _PointCardTile({required this.card});

  final PointCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 460,
      padding: const EdgeInsets.all(SlideSpacing.lg),
      decoration: SlideDecoration.card(accent: card.color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (card.emoji != null) ...[
            Text(card.emoji!, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: SlideSpacing.sm),
          ],
          Text(
            card.title,
            style: SlideTextStyles.subtitle.copyWith(color: card.color),
          ),
          if (card.description != null) ...[
            const SizedBox(height: SlideSpacing.sm),
            Text(card.description!, style: SlideTextStyles.caption),
          ],
        ],
      ),
    );
  }
}
