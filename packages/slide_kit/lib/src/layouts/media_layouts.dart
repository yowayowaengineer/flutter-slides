import 'dart:ui' as ui;

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
      padding:
          const EdgeInsets.symmetric(horizontal: SlideSpacing.md, vertical: 12),
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

  Widget _dot(Color color) => Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

/// ❌ と ✅ のコードを左右に並べて見比べるレイアウト。
///
/// [CodeLayout] は縦に長いコードをスクロールさせるが、登壇中にスクロールする
/// のは現実的でない。こちらは 2 つのコードを左右に分けて 1 画面に収める。
///
/// さらに、コードが枠に収まらない場合は折り返しでもスクロールでもなく
/// **縮小**して収める（[FittedBox]）。行の折り返しでコードの構造が崩れるのを
/// 避けるため。[fontSize] は縮小前の基準サイズ。
class CodeComparisonLayout extends StatelessWidget {
  const CodeComparisonLayout({
    super.key,
    required this.badCode,
    required this.goodCode,
    this.title,
    this.badLabel = '❌ やりがち',
    this.goodLabel = '✅ こう書く',
    this.accent = AppColors.blue,
    this.note,
    this.fontSize = 28,
  });

  /// 左に置く、うまくいかない方のコード。
  final String badCode;

  /// 右に置く、直した方のコード。
  final String goodCode;

  /// スライド上部の見出し。
  final String? title;

  /// 左右のカードの見出し。
  final String badLabel;
  final String goodLabel;

  final Color accent;

  /// 2 つのカードの下に置く補足（省略可）。
  final String? note;

  /// コードの基準フォントサイズ。収まらなければこれより小さく描画される。
  final double fontSize;

  static const _bad = Color(0xFFEF5350);
  static const _good = Color(0xFF4CAF50);

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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _CodeCard(
                    label: badLabel,
                    code: badCode,
                    color: _bad,
                    fontSize: fontSize,
                  ),
                ),
                const SizedBox(width: SlideSpacing.lg),
                Expanded(
                  child: _CodeCard(
                    label: goodLabel,
                    code: goodCode,
                    color: _good,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: SlideSpacing.md),
            Text(note!, style: SlideTextStyles.caption),
          ],
        ],
      ),
    );
  }
}

/// [CodeComparisonLayout] の片側。ラベル帯＋コード本体。
class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.label,
    required this.code,
    required this.color,
    required this.fontSize,
  });

  final String label;
  final String code;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SlideSpacing.md,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Text(
              label,
              style: SlideTextStyles.subtitle.copyWith(
                fontSize: 26,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(SlideSpacing.md),
              child: FittedBox(
                // 収まらないときは折り返さずに縮小する。左上基準で拡大はしない。
                fit: BoxFit.scaleDown,
                alignment: Alignment.topLeft,
                child: Text(
                  code,
                  softWrap: false,
                  style: SlideTextStyles.code.copyWith(fontSize: fontSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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

/// 画像を実寸のまま中央に置くレイアウト。
///
/// スライドの一部を切り出した画像を、実物のスライドに重なって見えるように
/// 出すためのもの。
///
/// このデッキは `FlutterDeckSlideSize.responsive()`（既定）で動くため、
/// flutter_deck は画面サイズに応じた拡大縮小を一切しない。文字は
/// [SlideTextStyles] の固定 px のまま描画される。
/// そこに全画面スクリーンショットを [BoxFit.cover] で敷くと、画像だけが
/// 画面幅に比例して伸縮し、実物の文字サイズとズレる。登壇先のプロジェクタが
/// 手元の PC と違う解像度だと露骨に出る。
///
/// このレイアウトは画像を伸縮させず、[width] / [height] で指定した論理 px
/// （1920x1080 基準）で描画して中央に置く。どちらも省略すると画像本来の
/// サイズになるので、高 DPI 環境で撮ったスクリーンショットを使うときは
/// [width] を明示したほうが安全。
///
/// `asSlide()` と組み合わせて使う。実物のスライドと同じコンテンツ領域の
/// 中央に載るので、切り出し位置さえ合っていれば重なって見える。
class CenteredImageLayout extends StatelessWidget {
  const CenteredImageLayout({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.placeholder,
  });

  /// 表示する画像。
  final ImageProvider image;

  /// 描画する幅（論理 px / 1920x1080 基準）。省略時は画像本来のサイズ。
  final double? width;

  /// 描画する高さ（論理 px / 1920x1080 基準）。省略時は画像本来のサイズ。
  final double? height;

  /// 画像が読み込めなかったときの代替表示（省略可）。
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(
        image: image,
        width: width,
        height: height,
        // 伸縮させない。width/height 指定時はその枠に収める。
        fit: width == null && height == null ? BoxFit.none : BoxFit.contain,
        errorBuilder: placeholder == null
            ? null
            : (context, error, stack) => placeholder!,
      ),
    );
  }
}

/// 画像 1 枚を余白なしでスライド全面に見せるレイアウト。
///
/// 「まず現象をどんと見せる」つかみのスライド向け。[CaptionedImageLayout] と
/// 違い、見出し・パディング・角丸を一切付けない。
///
/// 画像がスライド（16:9）と同じ比率とは限らないため、既定の [fit] は
/// [BoxFit.contain]。縦長のスクリーンショットや写真を渡しても切り落とさない。
/// 16:9 の画像を隅まで敷き詰めたいときだけ [BoxFit.cover] を指定する。
///
/// [fit] が [BoxFit.contain] のときにできる余白は既定でデッキ背景色になるが、
/// [blurBackdrop] を有効にすると画像自身をぼかして敷き、額縁のように見せる。
class FullBleedImageLayout extends StatelessWidget {
  const FullBleedImageLayout({
    super.key,
    required this.image,
    this.fit = BoxFit.contain,
    this.background,
    this.blurBackdrop = false,
    this.caption,
    this.placeholder,
  });

  /// 表示する画像。
  final ImageProvider image;

  /// 画像の収め方。既定は切り落とさない [BoxFit.contain]。
  final BoxFit fit;

  /// 余白を塗る色。既定は [AppColors.deckBackground]。
  final Color? background;

  /// 余白を画像自身のぼかしで埋めるか。
  ///
  /// 縦長・横長など比率の合わない画像を、余白を目立たせずに見せたいときに使う。
  /// [fit] が [BoxFit.cover] で余白が出ない場合は指定しても効果がない。
  final bool blurBackdrop;

  /// 画像の下端に重ねる小さなキャプション（省略可）。
  ///
  /// どんな画像の上でも読めるよう、下端に暗いグラデーションを敷く。
  final String? caption;

  /// 画像が読み込めなかったときに代わりに表示するウィジェット（省略可）。
  ///
  /// 実画像が揃うまでプレースホルダを出しておきたいときに使う。
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final fill = background ?? AppColors.deckBackground;

    Widget imageWidget = Image(
      image: image,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder:
          placeholder == null ? null : (context, error, stack) => placeholder!,
    );

    if (blurBackdrop) {
      imageWidget = Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Image(
              image: image,
              fit: BoxFit.cover,
              // ぼかした背景は主役ではないので少し沈ませる。
              color: Colors.black.withValues(alpha: 0.4),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stack) => const SizedBox.shrink(),
            ),
          ),
          imageWidget,
        ],
      );
    }

    return ColoredBox(
      color: fill,
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          if (caption != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                // 下端はフッター（高さ 40 + スライドパディング 16）を避ける。
                padding: const EdgeInsets.fromLTRB(
                  SlideSpacing.horizontal,
                  SlideSpacing.xl,
                  SlideSpacing.horizontal,
                  80,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Text(
                  caption!,
                  textAlign: TextAlign.center,
                  style: SlideTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
