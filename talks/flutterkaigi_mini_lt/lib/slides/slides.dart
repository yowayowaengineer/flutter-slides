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

      // あるある②：画像が出ない
      //
      // ②〜④は「見せる」から始める（①はタイトルで見せ済みなので説明から）。
      // 「見せる」＝実際に出た「画像が出ない」エラーのスクショ。
      // 説明の右は、存在しないパスの生の Image.asset。デバッグではコンソールに
      // エラーが出るが、リリース（登壇本番）ではエラーにならず画像が出ないだけ
      // ＝「画像が出ない」をその場でライブ実演できる。
      ...AruAruSection(
        id: '2',
        title: 'あるある② 画像が出ない',
        shotAsset: 'assets/images/aruaru2_shot.png',
        shotPlaceholderLabel: '画像が出ないエラー',
        symptom: '`Image.asset` で画像を出したのに\n'
            '真っ白、もしくは例外。\n\n'
            'たいていは `pubspec.yaml` の\n'
            '`assets:` への登録忘れか、\n'
            'パス・インデントのミス。',
        errorText: 'Unable to load asset:\n"assets/images/logo.png"',
        // わざと存在しないパス。errorBuilder は付けない（素の挙動を見せる）。
        // 上下中央に置く（実画像が入ったときも中央表示）。
        explainRight: Center(
          child: Image.asset('assets/images/dashumaru_typo.png'),
        ),
        lesson: '画像が出ない時は\nまず pubspec を疑え！',
      ).slides,

      // あるある③：テキストが崩れる
      // 見せる=崩れる様子の gif（縦長 856x1746 なので幅で縮める）、
      // 説明の右=正常ケースの gif。
      ...const AruAruSection(
        id: '3',
        title: 'あるある③ テキストが崩れる',
        shotAsset: 'assets/images/aruaru3_shot.gif',
        shotPlaceholderLabel: 'テキストが崩れる様子（gif）',
        shotWidth: 400,
        symptom: '`Text` を置いただけなのに\n'
            '黄色い二重下線＆極太文字に。\n\n'
            '`Material`（`Scaffold`）の外に\n'
            '`Text` を置くとこうなる。',
        errorText: '// エラーは出ない\n黄色い下線の Text が爆誕',
        photoAsset: 'assets/images/aruaru3_ok.gif',
        photoPlaceholderLabel: '正常ケースの動画（gif）',
        lesson: '黄色い下線が出たら\nMaterial の外にいる合図！',
      ).slides,

      // あるある④：入力が「？！おえういあ」になる
      // 記事: https://qiita.com/yowayowaengineer/items/b59ff3f8d6a2ce416220
      // 冒頭の「見せる」は日本語入力が崩れる様子の gif。説明は全幅テキスト。
      ...const AruAruSection(
        id: '4',
        title: 'あるある④ 入力が「？！おえういあ」',
        shotAsset: 'assets/images/aruaru4_shot.gif',
        shotPlaceholderLabel: '日本語入力が崩れる様子（gif）',
        shotWidth: 400,
        symptom: 'TextField に日本語を打つと\n'
            '「？！おえういあ」と\n'
            'おかしな順で入力される。\n\n'
            '原因は `build` の中で\n'
            '`TextEditingController` を\n'
            '毎回作り直していること。',
        errorText: '// エラーは出ない\n入力: ？！おえういあ',
        photoAsset: 'assets/images/aruaru4_ok.gif',
        photoPlaceholderLabel: '正常ケースの動画（gif）',
        lesson: 'Controller は build で作るな\ninitState で 1 回だけ！',
      ).slides,

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

      const ThanksSlide(),

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
        code: '''// ❌ Material が無いと黄色い二重下線＆極太になる
runApp(
  const Directionality(
    textDirection: TextDirection.ltr,
    child: Text('Hello'),   // ← DefaultTextStyle が無い
  ),
);

// ✅ MaterialApp / Scaffold の配下に置く
runApp(
  const MaterialApp(
    home: Scaffold(
      body: Center(child: Text('Hello')),
    ),
  ),
);

// スタイルは Theme.textTheme か TextStyle.copyWith で''',
        accent: AppColors.green,
      ).asSlide('/appendix-3'),

      const CodeLayout(
        title: 'Appendix④ Controller は initState で',
        filename: 'controller.dart',
        code: '''// ❌ build の中で毎回 Controller を作る
Widget build(BuildContext context) {
  final controller = TextEditingController(text: _message);
  return TextField(controller: controller);
}
// → 再ビルドのたびに作り直され、IME（日本語入力）が壊れる

// ✅ State のフィールドに持ち、initState で 1 回だけ
late final TextEditingController controller;

@override
void initState() {
  super.initState();
  controller = TextEditingController(text: _message);
}

@override
void dispose() {
  controller.dispose();   // 後始末も忘れずに
  super.dispose();
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

/// クロージング。オープニングのカバーと対になるよう、岡山.Flutter の
/// グラデ（[AppColors.primaryGradient]）背景＋白の極太「Thanks!!」。
class ThanksSlide extends FlutterDeckSlideWidget {
  const ThanksSlide()
      : super(
          configuration: const FlutterDeckSlideConfiguration(route: '/closing'),
        );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      backgroundBuilder: (context) => const DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Thanks!!',
              style: TextStyle(
                fontSize: 240,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
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
