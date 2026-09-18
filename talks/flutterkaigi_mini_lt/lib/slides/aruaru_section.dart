import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

import 'widgets.dart';

/// 「あるある」1 本ぶんを、決まった流れのスライドに展開する。
///
/// 1. **見せる** — 現象の画像を実寸のまま中央に出す（説明はまだしない）
/// 2. **説明** — 何が起きているかの概要＋補足の写真
/// 3. **教訓** — キメの一言
///
/// あるある①〜④をこの型で揃えることで、聞き手に「あーこういう流れね」と
/// 掴んでもらう。
///
/// 1 の「見せる」は [shotAsset] を省略すると出さない。あるある①のように、
/// タイトルスライド自体が現象の画像になっていて既に見せ終わっている場合は、
/// 同じ画像を二度出さずに説明から入る。
///
/// ```dart
/// ...AruAruSection(
///   id: '1',
///   title: 'あるある① オーバーフロー',
///   symptom: '...',
///   errorText: '...',
///   lesson: '...',
/// ).slides,
/// ```
class AruAruSection {
  const AruAruSection({
    required this.id,
    required this.title,
    required this.symptom,
    required this.errorText,
    required this.lesson,
    this.shotAsset,
    this.shotPlaceholderLabel,
    this.shotWidth,
    this.photoAsset,
    this.photoPlaceholderLabel,
    this.photoAspectRatio,
    this.explainRight,
  })  : assert(
          shotAsset == null || shotPlaceholderLabel != null,
          'shotAsset を指定するときは shotPlaceholderLabel も指定してください',
        ),
        assert(
          photoAsset == null || photoPlaceholderLabel != null,
          'photoAsset を指定するときは photoPlaceholderLabel も指定してください',
        );

  /// ルートの一部に使う識別子（例: `1` → `/aruaru-1`）。
  final String id;

  /// 説明スライドの見出し（例: `あるある① オーバーフロー`）。
  final String title;

  /// 「見せる」スライドに出す画像。省略するとこのスライド自体を出さない。
  final String? shotAsset;

  /// [shotAsset] が未配置のときに出すラベル。
  final String? shotPlaceholderLabel;

  /// 「見せる」画像を描画する幅（論理 px / 1920x1080 基準）。
  ///
  /// このデッキは画面サイズに応じた拡大縮小をしない（文字は固定 px）。
  /// 画像だけを画面いっぱいに引き伸ばすと、登壇先のプロジェクタの解像度が
  /// 手元と違ったときに実物の文字サイズとズレる。そのため画像は伸縮させず、
  /// ここで指定した実寸で中央に置く。
  ///
  /// 省略すると画像本来のサイズ。高 DPI 環境で撮ったスクリーンショットは
  /// ピクセル数が 2 倍になるので、その場合は明示する。
  final double? shotWidth;

  /// 説明スライドの症状テキスト。バッククォートで囲むとコードチップになる。
  final String symptom;

  /// 説明スライドに出すエラーメッセージ。
  final String errorText;

  /// 説明スライドの右側に置く写真（省略時はプレースホルダ枠）。
  final String? photoAsset;

  /// [photoAsset] が未配置のときに出すラベル。
  final String? photoPlaceholderLabel;

  /// 説明スライドの写真の縦横比（`1` で正方形）。
  ///
  /// 未配置時のプレースホルダも同じ枠に収まる。
  final double? photoAspectRatio;

  /// 説明スライドの右カラムに置く任意ウィジェット。
  ///
  /// 指定すると [photoAsset] / [photoPlaceholderLabel] より優先される。
  /// 「存在しない画像パスの生の `Image.asset`」を渡して、リリースビルドでは
  /// エラーにならず画像が出ないだけ、という挙動を実演するのに使う。
  final Widget? explainRight;

  /// 「教訓」のキメの一言。
  final String lesson;

  /// このあるある 1 本ぶんのスライド。
  List<FlutterDeckSlideWidget> get slides => [
        // ① 見せる（shotAsset 省略時はスキップ）
        //
        // 実物のスライドと同じコンテンツ領域の中央に、伸縮させず実寸で置く。
        // 全画面に引き伸ばすと登壇先の解像度次第で実物と文字サイズがズレる。
        if (shotAsset != null)
          CenteredImageLayout(
            image: AssetImage(shotAsset!),
            width: shotWidth,
            placeholder: ScreenshotPlaceholder(
              shotPlaceholderLabel!,
              accent: AppColors.pink,
            ),
          ).asSlide('/aruaru-$id-shot'),

        // ② 説明
        _explainSlide(),

        // ③ 教訓
        BigMessageLayout(message: lesson).asSlide('/aruaru-$id-lesson'),
      ];

  /// 説明スライド。右カラムの中身は次の優先順で決める:
  /// [explainRight] → [photoAsset] → [photoPlaceholderLabel] → （どれも無ければ全幅テキスト）。
  FlutterDeckSlideWidget _explainSlide() {
    final Widget? right = explainRight ??
        (photoAsset != null
            ? AssetPhoto(
                photoAsset!,
                placeholderLabel: photoPlaceholderLabel!,
                aspectRatio: photoAspectRatio,
              )
            : photoPlaceholderLabel != null
                ? ScreenshotPlaceholder(
                    photoPlaceholderLabel!,
                    accent: AppColors.pink,
                  )
                : null);

    if (right == null) return _explainFullWidth().asSlide('/aruaru-$id');

    return TwoColumnLayout(
      title: title,
      left: AruAruContent(symptom: symptom, errorText: errorText),
      right: right,
      // 縦長の gif/写真を少しでも大きく見せるため、上下の余白を詰める。
      padding: const EdgeInsets.symmetric(
        horizontal: SlideSpacing.horizontal,
        vertical: SlideSpacing.lg,
      ),
    ).asSlide('/aruaru-$id');
  }

  /// 右カラムを持たない全幅の「説明」（見出し＋症状＋エラー）。
  Widget _explainFullWidth() {
    return SlideFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideHeading(title, accent: AppColors.pink),
          const SizedBox(height: SlideSpacing.xl),
          Expanded(
            child: AruAruContent(symptom: symptom, errorText: errorText),
          ),
        ],
      ),
    );
  }
}
