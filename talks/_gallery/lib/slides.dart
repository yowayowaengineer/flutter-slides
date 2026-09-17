import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

/// カタログのスライド一覧。1 スライド = 1 レイアウト部品。
List<FlutterDeckSlideWidget> get gallerySlides => [
      // ── タイトル ──
      TitleLayout(
        titleSpans: const [
          TextSpan(text: 'slide_kit '),
          TextSpan(text: 'レイアウト', style: TextStyle(color: AppColors.blue)),
          TextSpan(text: 'カタログ'),
        ],
        subtitle: 'よく使うスライドの型を一覧する',
        eventName: 'flutter-slides / design preview',
      ).asSlide('/title'),

      // ── 自己紹介（共通部品）──
      WhoAmISlide(),

      // ── アジェンダ ──
      const AgendaLayout(
        items: [
          '章扉・キメ（SectionDivider / BigMessage）',
          '箇条書き（Bullet）',
          '2カラム・比較（TwoColumn / Comparison）',
          'カードグリッド（Cards）',
          '引用・コード・画像（Quote / Code / Image）',
        ],
      ).asSlide('/agenda'),

      // ── 章扉 ──
      const SectionDividerLayout(
        label: 'SECTION 01',
        title: '章扉レイアウト',
        subtitle: 'セクションの切り替えに。通し番号＋タイトル＋一言。',
      ).asSlide('/section-divider'),

      // ── キメの一言 ──
      const BigMessageLayout(
        message: 'Flutter は\nいいぞ。',
      ).asSlide('/big-message'),

      // ── 箇条書き ──
      const BulletLayout(
        title: '箇条書きレイアウト',
        bullets: [
          Bullet('普通の項目はこう表示される'),
          Bullet('強調したい項目は emphasis: true', emphasis: true),
          Bullet('ネストもできる', children: [
            Bullet('子項目 1'),
            Bullet('子項目 2'),
          ]),
          Bullet('色を個別指定もできる', color: AppColors.green),
        ],
      ).asSlide('/bullets'),

      // ── 2カラム ──
      TwoColumnLayout(
        title: '2カラムレイアウト',
        left: _demoPanel('左カラム', 'テキスト・画像・ウィジェットなど\n何でも置ける', AppColors.pink),
        right: _demoPanel('右カラム', 'flex 比率も変えられる\n（leftFlex / rightFlex）', AppColors.blue),
      ).asSlide('/two-column'),

      // ── 比較 ──
      const ComparisonLayout(
        title: '比較レイアウト',
        leftTitle: 'Before',
        rightTitle: 'After',
        leftItems: [
          '毎回ゼロから作る',
          'フッターを都度コピペ',
          'テーマがバラバラ',
        ],
        rightItems: [
          '共通部品を使い回す',
          'フッターは slide_kit',
          'テーマ統一',
        ],
      ).asSlide('/comparison'),

      // ── カードグリッド ──
      const CardsLayout(
        title: 'カードグリッド',
        cards: [
          PointCard(
            emoji: '⚡',
            title: '速い',
            description: 'ホットリロードで爆速',
            color: AppColors.blue,
          ),
          PointCard(
            emoji: '🎨',
            title: '綺麗',
            description: '共通テーマで統一感',
            color: AppColors.pink,
          ),
          PointCard(
            emoji: '♻️',
            title: '使い回せる',
            description: 'モノレポで量産',
            color: AppColors.green,
          ),
        ],
      ).asSlide('/cards'),

      // ── 引用 ──
      const QuoteLayout(
        quote: 'Talk is cheap.\nShow me the slides.',
        attribution: '— よわよわエンジニア',
      ).asSlide('/quote'),

      // ── コード ──
      const CodeLayout(
        title: 'コードレイアウト',
        filename: 'main.dart',
        code: '''import 'package:slide_kit/slide_kit.dart';

void main() {
  runApp(SlideDeckApp(slides: slides));
}

final slides = [
  TitleLayout(title: 'Hello').asSlide('/title'),
];''',
      ).asSlide('/code'),

      // ── クロージング ──
      const BigMessageLayout(
        message: 'この型を元に\n中身を書くだけ 🚀',
      ).asSlide('/closing'),
    ];

Widget _demoPanel(String title, String body, Color color) {
  return Container(
    height: double.infinity,
    padding: const EdgeInsets.all(SlideSpacing.lg),
    decoration: SlideDecoration.card(accent: color),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: SlideTextStyles.subtitle.copyWith(color: color)),
        const SizedBox(height: SlideSpacing.md),
        Text(body, style: SlideTextStyles.body),
      ],
    ),
  );
}
