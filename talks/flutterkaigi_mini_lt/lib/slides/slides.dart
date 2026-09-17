import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

import 'widgets.dart';

/// FlutterKaigi mini #6 @Okayama LT
/// 「Flutter初学者が知っておくべき4つのこと」
List<FlutterDeckSlideWidget> get slides => [
      // ══════════ つかみ（落選LT供養…させない）══════════

      // FlutterKaigi 2026 のカバー（ロゴはブランド規約NGのため文字＋ブランドグラデで表現）
      const EventCoverSlide(),

      const ProposalSlide(),

      const BigMessageLayout(message: '応募しました 📮')
          .asSlide('/applied'),

      const BigMessageLayout(
        message: 'その結果……',
        useGradient: false,
      ).asSlide('/result'),

      const BigMessageLayout(message: '落ちました！')
          .asSlide('/rejected'),

      // 6→7 で「供養……させません！」と繋げる（つかみの肝・2ページ）
      const BigMessageLayout(
        message: '今回はそのために作った\nLT を供養……',
        useGradient: false,
      ).asSlide('/memorial'),

      const BigMessageLayout(message: '……させません！')
          .asSlide('/not-really'),

      // 自己紹介（参考と同じ: 写真＋タップでスポットライト）
      PhotoIntroSlide(),

      // タイトル
      TitleLayout(
        titleSpans: const [
          TextSpan(text: 'Flutter初学者が\n知っておくべき'),
          TextSpan(text: '4つ', style: TextStyle(color: AppColors.blue)),
          TextSpan(text: 'のこと'),
        ],
        subtitle: '供養のはずが本編です',
        eventName: 'FlutterKaigi mini #6 @Okayama',
      ).asSlide('/title'),

      // ══════════ 本編：Flutter あるある ══════════

      const SectionDividerLayout(
        label: 'MAIN',
        title: 'Flutter あるある 4連発',
        subtitle: '初学者がだいたい一度は踏むやつ',
      ).asSlide('/aruaru-intro'),

      // あるある①：オーバーフロー
      TwoColumnLayout(
        title: 'あるある① オーバーフロー 🟨⬛',
        left: const AruAruContent(
          symptom: 'Row / Column に要素を並べたら\n画面からはみ出して\n黄色と黒の縞々が出る。',
          errorText: 'A RenderFlex overflowed by\n137 pixels on the right.',
          shotLabel: 'オーバーフローの縞々',
        ),
        right: const ScreenshotPlaceholder('オーバーフロー画面', accent: AppColors.pink),
      ).asSlide('/aruaru-1'),

      // あるある②：画像読み取りエラー
      TwoColumnLayout(
        title: 'あるある② 画像が出ない 🖼️',
        left: const AruAruContent(
          symptom: '画像を置いたのに表示されない。\nコンソールには例外が。',
          errorText: 'Unable to load asset:\n"images/logo.png".',
          shotLabel: '画像が出ない画面',
        ),
        right: const ScreenshotPlaceholder('画像エラー画面', accent: AppColors.pink),
      ).asSlide('/aruaru-2'),

      // あるある③：テキストスタイル崩れ
      TwoColumnLayout(
        title: 'あるある③ テキストが崩れる 🔤',
        left: const AruAruContent(
          symptom: 'Text を置いただけなのに\n黄色い二重下線＆極太文字に。\n（Material の外に置くとコレ）',
          errorText: '// no error, but…\n黄色い下線の Text が爆誕',
          shotLabel: '黄色い下線テキスト',
        ),
        right: const ScreenshotPlaceholder('崩れたテキスト', accent: AppColors.pink),
      ).asSlide('/aruaru-3'),

      // あるある④：State をクラスの外に書いた
      TwoColumnLayout(
        title: 'あるある④ 状態がどこかおかしい 🧠',
        left: const AruAruContent(
          symptom: '「なしなし」だけど……\nState をクラスの外に書いてしまい\nsetState しても・共有されて\n変な挙動に。',
          errorText: 'setState() called\nbut nothing updates…?',
          shotLabel: '更新されない画面',
        ),
        right: const ScreenshotPlaceholder('状態バグの画面', accent: AppColors.pink),
      ).asSlide('/aruaru-4'),

      // ══════════ クロージング ══════════

      const BulletLayout(
        title: '岡山.Flutter の取り組み 🍩☕',
        bullets: [
          Bullet('岡山で Flutter コミュニティやってます', emphasis: true),
          Bullet('もくもく会 / LT会 / 初学者歓迎'),
          Bullet('「あるある」を一緒に踏んで一緒に抜け出そう'),
          Bullet('気軽に参加してね！', color: AppColors.green),
        ],
      ).asSlide('/okayama-flutter'),

      const BigMessageLayout(message: '供養、\n完了！\nありがとうございました 🙏')
          .asSlide('/closing'),

      // ══════════ Appendix（初学者向け解説）══════════

      const SectionDividerLayout(
        label: 'APPENDIX',
        title: '解説：あるあるの直し方',
        subtitle: 'ここからは真面目に',
        accent: AppColors.green,
      ).asSlide('/appendix-intro'),

      const CodeLayout(
        title: 'Appendix① オーバーフローの直し方',
        filename: 'overflow.dart',
        code: '''// ❌ はみ出す
Row(
  children: [
    Text('とても長いテキストが入ります……'),
    Icon(Icons.star),
  ],
)

// ✅ Expanded / Flexible で包む
Row(
  children: [
    Expanded(
      child: Text(
        'とても長いテキストが入ります……',
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.star),
  ],
)
// 他: Wrap / SingleChildScrollView / FittedBox''',
        accent: AppColors.green,
      ).asSlide('/appendix-1'),

      const CodeLayout(
        title: 'Appendix② 画像が出ないの直し方',
        filename: 'pubspec.yaml',
        code: '''# pubspec.yaml に assets を宣言（インデント注意）
flutter:
  assets:
    - images/logo.png      # or - images/

# そのあと必ず:
#   flutter pub get
#   ホットリスタート（ホットリロードでは反映されない）

# 保険として errorBuilder を付けると安心
Image.asset(
  'images/logo.png',
  errorBuilder: (context, error, stack) => Icon(Icons.broken_image),
)''',
        accent: AppColors.green,
      ).asSlide('/appendix-2'),

      const CodeLayout(
        title: 'Appendix③ テキスト崩れの直し方',
        filename: 'text_style.dart',
        code: '''// ❌ Material の外に Text を置くと黄色い下線
runApp(
  Text('Hello'),
);

// ✅ MaterialApp / Scaffold の配下に置く
runApp(
  MaterialApp(
    home: Scaffold(
      body: Center(child: Text('Hello')),
    ),
  ),
);

// スタイルは Theme.textTheme か TextStyle.copyWith で''',
        accent: AppColors.green,
      ).asSlide('/appendix-3'),

      const CodeLayout(
        title: 'Appendix④ 状態の持ち方',
        filename: 'state.dart',
        code: '''// ❌ State の外（トップレベル）に状態
int count = 0;

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => count++),
    child: Text('\$count'),
  );
}

// ✅ State の中に持つ
class _CounterState extends State<Counter> {
  int count = 0;              // ← ここ
  // 画面をまたぐ状態は Provider / Riverpod で管理
}''',
        accent: AppColors.green,
      ).asSlide('/appendix-4'),
    ];

/// プロポーザル。スピーカー特典のぬいぐるみ「だしゅまるくん」欲しさに応募した、の図。
///
/// 画像は `assets/images/dashumaru.png` を置いて pubspec の assets を有効化すると
/// 表示される。未配置の間はプレースホルダにフォールバックする。
class ProposalSlide extends FlutterDeckSlideWidget {
  const ProposalSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(route: '/proposal'),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SlideSpacing.horizontal,
          vertical: SlideSpacing.vertical,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LT 登壇のプロポーザル',
              textAlign: TextAlign.center,
              style: SlideTextStyles.headline.copyWith(fontSize: 56),
            ),
            const SizedBox(height: SlideSpacing.lg),
            Expanded(
              child: Image.asset(
                'assets/images/dashumaru.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const ScreenshotPlaceholder(
                  'だしゅまるくん（スピーカー特典）',
                  accent: AppColors.pink,
                ),
              ),
            ),
            const SizedBox(height: SlideSpacing.md),
            Text(
              '…このぬいぐるみ「だしゅまるくん」欲しさに 📮',
              textAlign: TextAlign.center,
              style: SlideTextStyles.caption.copyWith(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}

/// つかみ1枚目。イベントのカバー。
///
/// FlutterKaigi のロゴはブランド規約で使いにくいため、公式サイトの
/// ブランドグラデ（赤〜紫）を背景に、白のゴシック太字でイベント名だけを出す。
class EventCoverSlide extends FlutterDeckSlideWidget {
  const EventCoverSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(route: '/cover'),
        );

  static const _brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE81765), Color(0xFF9A1FBE), Color(0xFF5E2CE0)],
    stops: [0.0, 0.55, 1.0],
  );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      backgroundBuilder: (context) => const DecoratedBox(
        decoration: BoxDecoration(gradient: _brandGradient),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'FlutterKaigi mini #6',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                // 2行目「@Okayama」をドンと大きく・極太・少し傾けて馬鹿っぽく
                Transform.rotate(
                  angle: -0.04,
                  child: const Text(
                    '@Okayama',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 240,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
