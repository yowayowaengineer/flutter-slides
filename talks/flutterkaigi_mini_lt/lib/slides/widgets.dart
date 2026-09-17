import 'package:flutter/material.dart';
import 'package:slide_kit/slide_kit.dart';

/// 画像アセットを角丸で表示し、未配置なら [ScreenshotPlaceholder] に落とす。
///
/// 実画像が揃う前でもデッキを通しで確認できるようにするための部品。
/// 比率がまちまちな写真を想定して、既定の [fit] は切り落とさない
/// [BoxFit.contain]。
class AssetPhoto extends StatelessWidget {
  const AssetPhoto(
    this.asset, {
    super.key,
    required this.placeholderLabel,
    this.fit = BoxFit.contain,
    this.accent = AppColors.pink,
    this.aspectRatio,
  });

  /// `assets/images/...` 形式のアセットパス。
  final String asset;

  /// 未配置のときにプレースホルダへ出すラベル。
  final String placeholderLabel;

  final BoxFit fit;
  final Color accent;

  /// 表示枠の縦横比（`1` で正方形）。省略すると与えられた領域いっぱい。
  ///
  /// 指定すると領域の中央にその比率の枠を置く。未配置時のプレースホルダも
  /// 同じ枠に収まるので、画像の有無で見た目が変わらない。
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final photo = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        asset,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stack) =>
            ScreenshotPlaceholder(placeholderLabel, accent: accent),
      ),
    );

    if (aspectRatio == null) return photo;

    return Center(
      child: AspectRatio(aspectRatio: aspectRatio!, child: photo),
    );
  }
}

/// スクショ差し込み枠。あとで実画像に差し替える。
class ScreenshotPlaceholder extends StatelessWidget {
  const ScreenshotPlaceholder(this.label,
      {super.key, this.accent = AppColors.blue});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.5), width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 72, color: accent),
            const SizedBox(height: SlideSpacing.md),
            Text(
              'スクショ: $label',
              textAlign: TextAlign.center,
              style: SlideTextStyles.caption.copyWith(fontSize: 26),
            ),
          ],
        ),
      ),
    );
  }
}

/// あるある本編スライドの中身（左: 症状＋エラー / 右: スクショ枠）。
class AruAruContent extends StatelessWidget {
  const AruAruContent({
    super.key,
    required this.symptom,
    required this.errorText,
    this.accent = AppColors.pink,
  });

  final String symptom;
  final String errorText;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // 文字量が少ないので、右の写真に対して上下中央で釣り合わせる。
    // Center が高さいっぱいに広がり、その中で Column が縮んで中央に乗る。
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // symptom 内の `Column` のような表記はコードチップとして描画される。
          InlineCodeText(
            symptom,
            style: SlideTextStyles.body.copyWith(fontSize: 34),
          ),
          const SizedBox(height: SlideSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SlideSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF3A0D0D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEF5350).withValues(alpha: 0.6),
              ),
            ),
            child: Text(
              errorText,
              style: SlideTextStyles.code.copyWith(
                fontSize: 22,
                color: const Color(0xFFFF8A80),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
