import 'dart:async';

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
        message: '応募しました',
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

      // 中盤の小ネタ：突貫制作アピール → タイトル再掲
      const _BddContent().asSlide('/bdd'),
      _compressionSlide().asSlide('/compression'),
      _slideCountSlide().asSlide('/slide-count'),

      // タイトル再掲（このオーバーフローを あるある① で回収）
      const CenteredImageLayout(
        image: AssetImage('assets/images/overflow_title.png'),
        placeholder: ScreenshotPlaceholder(
          'タイトル（オーバーフローさせたもの）',
          accent: AppColors.blue,
        ),
      ).asSlide('/title-2'),

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
        // 右で実際に読み込ませている存在しないパスと一致させること。
        // パスを変えたらこの文言も揃え直す。
        errorText: 'Unable to load asset:\n"assets/images/dashumaru_typo.png"',
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
        // 実際のスタイルは color: 0xD0FF0000（赤）＋ decorationColor: 0xFFFFFF00
        // の二重下線。gif に映る見た目と言葉を一致させている。
        symptom: '`Text` を置いただけなのに\n'
            '黄色い二重下線＆赤い極太文字に。\n\n'
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

      // あるある → コミュニティ紹介 の橋渡し。初学者へのメッセージ。
      _messageSlide().asSlide('/message'),

      // ══════════ クロージング ══════════

      const BulletLayout(
        title: '岡山.Flutter の取り組み 🍩☕',
        bullets: [
          Bullet('岡山で Flutter コミュニティやってます', emphasis: true),
          Bullet('もくもく会 / LT会 / 初学者歓迎'),
          Bullet('「あるある」を踏んだ話を持ち寄って抜け出そう'),
          Bullet('気軽に参加してね！', color: AppColors.pink),
        ],
      ).asSlide('/okayama-flutter'),

      const ThanksSlide(),

      // ══════════ Appendix（初学者向け解説）══════════

      _appendixIntroSlide().asSlide('/appendix-intro'),

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

      const CodeComparisonLayout(
        title: 'Appendix① オーバーフローの直し方',
        accent: AppColors.green,
        badCode: '''Row(
  children: [
    Text('とても長いテキストが入ります……'),
    Icon(Icons.star),
  ],
)

// はみ出した分だけ縞々が出る''',
        goodCode: '''Row(
  children: [
    Expanded(
      child: Text(
        'とても長いテキストが入ります……',
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.star),
  ],
)''',
        note: '他の手: Wrap / SingleChildScrollView / FittedBox',
      ).asSlide('/appendix-1'),

      const BulletLayout(
        title: 'Appendix② 画像が出ないとは',
        accent: AppColors.green,
        bullets: [
          Bullet('画像は `pubspec.yaml` の `assets:` に宣言したものだけが同梱される'),
          Bullet('宣言し忘れ・パス違い・インデントミスで「Unable to load asset」'),
          Bullet('`assets:` を変えたら `flutter pub get` が必要'),
          Bullet('反映はホットリロードではなくホットリスタート（or 再ビルド）', emphasis: true),
          Bullet('`- assets/images/` とフォルダ指定で中身をまとめて含められる'),
        ],
      ).asSlide('/appendix-2-what'),

      const CodeComparisonLayout(
        title: 'Appendix② 画像が出ないの直し方',
        accent: AppColors.green,
        badCode: '''# pubspec.yaml
flutter:
  uses-material-design: true
  # assets: を書き忘れている

# コード側
Image.asset('images/logo.png')

// Unable to load asset: "images/logo.png"''',
        goodCode: '''# pubspec.yaml（インデントに注意）
flutter:
  assets:
    - images/logo.png   # or - images/

# 書き換えたあと必ず
#   flutter pub get
#   ホットリスタート
#   （ホットリロードでは反映されない）''',
        note: '保険として Image.asset に errorBuilder を付けておくと、出ないときに気づける',
      ).asSlide('/appendix-2'),

      const BulletLayout(
        title: 'Appendix③ テキストが崩れるとは',
        accent: AppColors.green,
        bullets: [
          Bullet('`Text` は祖先の `DefaultTextStyle` からスタイルを受け取る'),
          Bullet('`MaterialApp` は「Material の外にいるぞ」と気づかせる警告用スタイルを敷く'),
          Bullet('`Scaffold`（`Material`）の配下に入ると、そこで適切なスタイルに上書きされる'),
          Bullet('上書きされないまま描かれると、黄色い二重下線＆赤い極太文字になる', emphasis: true),
          Bullet('`MaterialApp` の `home` に `Scaffold` を挟み忘れると起きがち'),
          Bullet('対策: `Scaffold` 配下に置く／必要なら `DefaultTextStyle` で囲む'),
        ],
      ).asSlide('/appendix-3-what'),

      const CodeComparisonLayout(
        title: 'Appendix③ テキスト崩れの直し方',
        accent: AppColors.green,
        badCode: '''runApp(
  const MaterialApp(
    home: Center(
      child: Text('Hello'),
    ),
  ),
);

// Scaffold が無い
// → 黄色い二重下線＆赤い極太''',
        goodCode: '''runApp(
  const MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Hello'),
      ),
    ),
  ),
);''',
        note: 'スタイルは Theme.of(context).textTheme か TextStyle.copyWith で整える',
      ).asSlide('/appendix-3'),

      const BulletLayout(
        title: 'Appendix④ 入力が崩れるとは',
        accent: AppColors.green,
        bullets: [
          Bullet('`build` は状態が変わるたび何度も呼ばれる'),
          Bullet('その中で `TextEditingController` を new すると毎回別物になる'),
          Bullet('IME（日本語）の変換途中がリセットされ「？！おえういあ」に', emphasis: true),
          Bullet('Controller は `State` のフィールドに持ち `initState` で 1 回だけ生成'),
          Bullet('`dispose` で破棄してリークを防ぐ'),
        ],
      ).asSlide('/appendix-4-what'),

      const CodeComparisonLayout(
        title: 'Appendix④ Controller は initState で',
        accent: AppColors.green,
        badCode: '''Widget build(BuildContext context) {
  final controller =
      TextEditingController(text: _message);
  return TextField(controller: controller);
}

// build は何度も呼ばれる
// → 毎回作り直されて IME が壊れる''',
        goodCode: '''late final TextEditingController controller;

@override
void initState() {
  super.initState();
  controller =
      TextEditingController(text: _message);
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}''',
        note: 'Controller は State のフィールドに持ち、initState で 1 回だけ作る',
      ).asSlide('/appendix-4'),
    ];

/// あるある → コミュニティ紹介 の橋渡し。Flutter初学者への応援メッセージ。
Widget _messageSlide() {
  final body = SlideTextStyles.body.copyWith(fontSize: 38);
  // 「前置き → グラデの決め台詞」を 2 セット並べる。
  // 前置きと決め台詞の間は 2 セットとも同じ [lead]、セット同士の区切りは
  // それより広い [group] にして、まとまりが見えるようにする。
  const lead = SlideSpacing.xl;
  const group = 96.0;
  return SlideFrame(
    // 縦中央。文字だけのスライドなので上寄せだと下half が空いて間延びする。
    alignment: Alignment.center,
    child: FittedBox(
      // 念のため。文言を足して縦に溢れても縮んで収まる。
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Flutter初学者のあなたへ',
            textAlign: TextAlign.center,
            style: SlideTextStyles.title.copyWith(
              color: AppColors.blue,
              fontSize: 52,
            ),
          ),
          const SizedBox(height: group),
          // セット1
          Text('あるあるは、みんなが通る道。', textAlign: TextAlign.center, style: body),
          const SizedBox(height: SlideSpacing.sm),
          Text('ここにいるベテランもみんな経験しています。',
              textAlign: TextAlign.center, style: body),
          const SizedBox(height: lead),
          _gradientWord('怖がらず、書いていこう！', fontSize: 72),
          const SizedBox(height: group),
          // セット2（セット1と同じ間隔で決め台詞へ繋ぐ）
          Text('そして、一人で悩まないで', textAlign: TextAlign.center, style: body),
          const SizedBox(height: lead),
          _gradientWord('聞いていこう！', fontSize: 72),
        ],
      ),
    ),
  );
}

/// Appendix の章扉。中央に大きく「Appendix」＋補足。
Widget _appendixIntroSlide() {
  return SlideFrame(
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Appendix',
          textAlign: TextAlign.center,
          style: SlideTextStyles.display.copyWith(fontSize: 140),
        ),
        const SizedBox(height: SlideSpacing.md),
        Text(
          '（あるあるネタの補足）',
          textAlign: TextAlign.center,
          style: SlideTextStyles.subtitle.copyWith(
            fontSize: 44,
            fontWeight: FontWeight.w400,
            color: AppColors.deckText.withValues(alpha: 0.7),
          ),
        ),
      ],
    ),
  );
}

/// 岡山.Flutter グラデを文字に乗せる（強調ワード用）。
Widget _gradientWord(String text, {required double fontSize}) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1.1,
      ),
    ),
  );
}

TextStyle get _punchStyle => SlideTextStyles.display.copyWith(fontSize: 72);

/// BDD（勉強会・駆動・開発）のネタスライド。
/// サブタイトルは 3 秒後にふわっと（下から＋フェード）表示する。
class _BddContent extends StatefulWidget {
  const _BddContent();

  @override
  State<_BddContent> createState() => _BddContentState();
}

class _BddContentState extends State<_BddContent> {
  bool _reveal = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _reveal = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _gradientWord('BDD', fontSize: 220),
              const SizedBox(height: SlideSpacing.md),
              // 3 秒後にふわっと表示。非表示中も場所は確保（BDD が動かない）。
              AnimatedSlide(
                offset: _reveal ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: _reveal ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: Text(
                    '（勉強会・駆動・開発）',
                    textAlign: TextAlign.center,
                    style: SlideTextStyles.subtitle.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 「通常1週間のところを3日間 → 2倍の期間圧縮！」（2倍だけグラデ）。
Widget _compressionSlide() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80),
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('通常1週間のところを3日間',
                textAlign: TextAlign.center, style: _punchStyle),
            const SizedBox(height: SlideSpacing.lg),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('つまり', style: _punchStyle),
                _gradientWord('2倍', fontSize: 120),
                Text('の期間圧縮！', style: _punchStyle),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// 「スライド数も 2倍!?」（2倍!?だけグラデ）＋補足。
Widget _slideCountSlide() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80),
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('スライド数も', textAlign: TextAlign.center, style: _punchStyle),
            const SizedBox(height: SlideSpacing.md),
            _gradientWord('2倍!?', fontSize: 180),
            const SizedBox(height: SlideSpacing.lg),
            // ◯スライド = デッキ総数（Appendix 含む）。増減したら数字を更新。
            Text(
              '（5分のLTに対して36スライド）',
              textAlign: TextAlign.center,
              style: SlideTextStyles.subtitle.copyWith(fontSize: 44),
            ),
          ],
        ),
      ),
    ),
  );
}

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
      // 横長画像（1051x812）を大きく見せたいので上下の余白を詰め、
      // 見出し・キャプションもコンパクトに。全要素を中央寄せ。
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'LT 登壇のプロポーザル',
              textAlign: TextAlign.center,
              style: SlideTextStyles.headline.copyWith(fontSize: 48),
            ),
            const SizedBox(height: SlideSpacing.sm),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/dashumaru.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stack) =>
                      const ScreenshotPlaceholder(
                    'だしゅまるくん（スピーカー特典）',
                    accent: AppColors.pink,
                  ),
                ),
              ),
            ),
            const SizedBox(height: SlideSpacing.sm),
            Text(
              '…このぬいぐるみ「だしゅまるくん」欲しさに',
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
