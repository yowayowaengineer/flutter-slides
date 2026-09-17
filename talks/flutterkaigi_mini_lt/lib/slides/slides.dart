import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

import 'aruaru_section.dart';
import 'widgets.dart';

/// FlutterKaigi のブランドグラデ（赤〜紫）。
///
/// タイトルスライドより前の「つかみ」パートで使う。ロゴはブランド規約で
/// 使いにくいため、色だけを借りてイベントの文脈を示す。
/// タイトル以降は岡山.Flutter 側の [AppColors.primaryGradient] に切り替える。
const flutterKaigiGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFE81765), Color(0xFF9A1FBE), Color(0xFF5E2CE0)],
  stops: [0.0, 0.55, 1.0],
);

/// FlutterKaigi mini #6 @Okayama LT
/// 「Flutter初学者が知っておくべき4つのこと」
List<FlutterDeckSlideWidget> get slides => [
      // ══════════ つかみ（落選LT供養…させない）══════════

      // FlutterKaigi 2026 のカバー（ロゴはブランド規約NGのため文字＋ブランドグラデで表現）
      const EventCoverSlide(),

      const ProposalSlide(),

      const BigMessageLayout(
        message: '応募しました 📮',
        gradient: flutterKaigiGradient,
      ).asSlide('/applied'),

      const BigMessageLayout(
        message: 'その結果……',
        useGradient: false,
      ).asSlide('/result'),

      const BigMessageLayout(
        message: '落ちました！',
        gradient: flutterKaigiGradient,
      ).asSlide('/rejected'),

      // 6→7 で「供養……させません！」と繋げる（つかみの肝・2ページ）
      const BigMessageLayout(
        message: '今回はそのために作った\nLT を供養……',
        useGradient: false,
      ).asSlide('/memorial'),

      const BigMessageLayout(
        message: '……させません！',
        gradient: flutterKaigiGradient,
      ).asSlide('/not-really'),

      // 自己紹介（参考と同じ: 写真＋タップでスポットライト）
      PhotoIntroSlide(),

      // タイトル。
      //
      // 実はこの時点でオーバーフローしている画像を出している。聞き手はここでは
      // 気づかず、あるある①で「さっきのこれ」として回収する。
      //
      // 実ウィジェットで本当にオーバーフローさせない理由: 縞々はデバッグビルド
      // でしか描画されないため、リリースビルドで登壇すると消えてしまう。
      // 画像なら確実に出る。
      const CenteredImageLayout(
        image: AssetImage('assets/images/overflow_title.png'),
        placeholder: ScreenshotPlaceholder(
          'タイトル（オーバーフローさせたもの）',
          accent: AppColors.blue,
        ),
      ).asSlide('/title'),

      // あるある①：オーバーフロー
      //
      // 現象はタイトルスライドで見せ済みなので、同じ画像を二度出さず
      // 説明から入る。②③④は「見せる」から始める。
      ...const AruAruSection(
        id: '1',
        title: 'あるある① オーバーフロー',
        symptom: '`Column` はウィジェットを\n'
            '縦に並べるウィジェット。\n\n'
            'その中のウィジェットが\n'
            '`Column` の高さに収まらなかった状態。\n\n'
            'はみ出した側に「縞々」が出て、\n'
            '何 px はみ出したかを教えてくれる。',
        // 1 枚目の画像の縞々に出ている文言そのもの。
        // 画像を撮り直したら数字と向きを揃え直すこと。
        errorText: 'BOTTOM OVERFLOWED BY 29 PIXELS',
        photoAsset: 'assets/images/sticker_overflow.jpg',
        photoPlaceholderLabel: 'FlutterKaigi 2025 のステッカー\n（だしゅまる＆オーバーフロー）',
        photoAspectRatio: 1,
        lesson: '初学者は\n必ず見ることになる。\n気をつけろ！',
      ).slides,

      // あるある②：画像読み取りエラー
      TwoColumnLayout(
        title: 'あるある② 画像が出ない',
        left: const AruAruContent(
          symptom: '画像を置いたのに表示されない。\nコンソールには例外が。',
          errorText: 'Unable to load asset:\n"images/logo.png".',
        ),
        right: const ScreenshotPlaceholder('画像エラー画面', accent: AppColors.pink),
      ).asSlide('/aruaru-2'),

      // あるある③：テキストスタイル崩れ
      TwoColumnLayout(
        title: 'あるある③ テキストが崩れる',
        left: const AruAruContent(
          symptom: 'Text を置いただけなのに\n黄色い二重下線＆極太文字に。\n（Material の外に置くとコレ）',
          errorText: '// no error, but…\n黄色い下線の Text が爆誕',
        ),
        right: const ScreenshotPlaceholder('崩れたテキスト', accent: AppColors.pink),
      ).asSlide('/aruaru-3'),

      // あるある④：State をクラスの外に書いた
      TwoColumnLayout(
        title: 'あるある④ 状態がどこかおかしい',
        left: const AruAruContent(
          symptom: 'エラーは出ない。なのに画面が変わらない。\n'
              '状態を State クラスの外に書くと\n'
              'setState しても反映されず、\n'
              '別の画面とも共有されてしまう。',
          errorText: 'setState() called\nbut nothing updates…?',
        ),
        right: const ScreenshotPlaceholder('状態バグの画面', accent: AppColors.pink),
      ).asSlide('/aruaru-4'),

      // ══════════ クロージング ══════════

      const BulletLayout(
        title: '岡山.Flutter の取り組み 🍩☕',
        bullets: [
          Bullet('岡山で Flutter コミュニティやってます', emphasis: true),
          Bullet('もくもく会 / LT会 / 初学者歓迎'),
          Bullet('「あるある」を踏んだ話を持ち寄って抜け出そう'),
          Bullet('気軽に参加してね！', color: AppColors.green),
        ],
      ).asSlide('/okayama-flutter'),

      const BigMessageLayout(message: 'ありがとうございました 🙏').asSlide('/closing'),

      // ══════════ Appendix（初学者向け解説）══════════

      const SectionDividerLayout(
        label: 'APPENDIX',
        title: '解説：あるあるの直し方',
        subtitle: 'ここからは真面目に',
        accent: AppColors.green,
      ).asSlide('/appendix-intro'),

      // 本編のあるある①は口頭で補う前提で削ってある。
      // そこで話した中身を、見返せるようにこちらへ残す。
      const BulletLayout(
        title: 'Appendix① オーバーフローとは',
        accent: AppColors.green,
        bullets: [
          Bullet('`Row` は横、`Column` は縦に子を並べる'),
          Bullet('子の合計が親から渡された大きさを超えても、勝手には縮めてくれない'),
          Bullet('基準は画面幅ではなく、親のウィジェットから渡された大きさ'),
          Bullet('はみ出した側に縞々が出て、何 px 超えたかを教えてくれる'),
          Bullet('縞々が出るのはデバッグビルドのときだけ', emphasis: true),
          Bullet('リリースでは出ないが、はみ出した分は見切れたまま（直ってはいない）'),
        ],
      ).asSlide('/appendix-1-what'),

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
        code: '''// ❌ Material（Scaffold）の外の Text は黄色い二重下線
runApp(
  MaterialApp(
    home: Center(child: Text('Hello')),
  ),
);

// ✅ Scaffold（Material）の配下に置く
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
          configuration:
              const FlutterDeckSlideConfiguration(route: '/proposal'),
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
                errorBuilder: (context, error, stack) =>
                    const ScreenshotPlaceholder(
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

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      backgroundBuilder: (context) => const DecoratedBox(
        decoration: BoxDecoration(gradient: flutterKaigiGradient),
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
