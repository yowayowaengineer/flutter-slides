import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../model/speaker_profile.dart';

/// 写真＋タップ演出の自己紹介スライド。
///
/// 背景いっぱいのイベント写真を表示し、写真内の顔の位置（[focusFraction]）を
/// タップするとスポットライト＋プロフィールカードがポップする。
///
/// スポットライト位置は「背景画像内の割合(0..1)」で指定する。実際に表示された
/// 画像の矩形（[BoxFit.cover] の拡大・切り取り）を計算して画面座標へ変換するため、
/// ウィンドウのアスペクト比が変わっても常に同じ被写体の位置に一致する。
///
/// 既定は FlutterKaigi2025 の写真＋[SpeakerProfile.yowayowa]。
class PhotoIntroSlide extends FlutterDeckSlideWidget {
  PhotoIntroSlide({
    super.key,
    this.profile = SpeakerProfile.yowayowa,
    this.background = const AssetImage(
      'assets/images/FlutterKaigi2025.webp',
      package: 'slide_kit',
    ),
    this.focusFraction = const Offset(0.539, 0.680),
    this.focusDiameterFraction = 0.03,
    this.showFocusRing = false,
    this.title = '👋 よわよわエンジニア is 誰',
    String route = '/who-am-i',
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route,
            header: FlutterDeckHeaderConfiguration(title: title),
          ),
        );

  final SpeakerProfile profile;

  /// 背景に敷くイベント写真。
  final ImageProvider background;

  /// スポットライトの中心（背景画像内の割合 0..1）。
  final Offset focusFraction;

  /// スポットライトの直径（表示された画像の幅に対する割合）。
  final double focusDiameterFraction;

  /// 位置合わせ用。true にするとタップ前でも焦点にリングを表示する。
  final bool showFocusRing;

  final String title;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => _PhotoIntroBody(
        background: background,
        focusFraction: focusFraction,
        focusDiameterFraction: focusDiameterFraction,
        showFocusRing: showFocusRing,
        profile: profile,
      ),
    );
  }
}

class _PhotoIntroBody extends StatefulWidget {
  const _PhotoIntroBody({
    required this.background,
    required this.focusFraction,
    required this.focusDiameterFraction,
    required this.showFocusRing,
    required this.profile,
  });

  final ImageProvider background;
  final Offset focusFraction;
  final double focusDiameterFraction;
  final bool showFocusRing;
  final SpeakerProfile profile;

  @override
  State<_PhotoIntroBody> createState() => _PhotoIntroBodyState();
}

class _PhotoIntroBodyState extends State<_PhotoIntroBody> {
  final GlobalKey _targetKey = GlobalKey();
  ImageStream? _stream;
  ImageStreamListener? _listener;
  Size? _imageSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 背景画像の実寸（アスペクト比）を得るために解決する。
    final stream = widget.background.resolve(createLocalImageConfiguration(context));
    if (stream.key != _stream?.key) {
      if (_listener != null) _stream?.removeListener(_listener!);
      _listener = ImageStreamListener((info, _) {
        if (!mounted) return;
        setState(() {
          _imageSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        });
      });
      _stream = stream..addListener(_listener!);
    }
  }

  @override
  void dispose() {
    if (_listener != null) _stream?.removeListener(_listener!);
    super.dispose();
  }

  void _showTutorial() {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'speaker',
          keyTarget: _targetKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) => _ProfilePopup(profile: widget.profile),
            ),
          ],
        ),
      ],
      colorShadow: Colors.black.withValues(alpha: 0.8),
      textSkip: '閉じる',
      paddingFocus: 10,
      opacityShadow: 0.8,
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTutorial,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final box = Size(constraints.maxWidth, constraints.maxHeight);
          final rect = _coverRect(_imageSize, box);

          // 画像実寸が未解決の間は、コンテンツ領域に対する割合で暫定配置。
          final center = rect == null
              ? Offset(
                  box.width * widget.focusFraction.dx,
                  box.height * widget.focusFraction.dy,
                )
              : Offset(
                  rect.left + widget.focusFraction.dx * rect.width,
                  rect.top + widget.focusFraction.dy * rect.height,
                );
          final diameter = (rect?.width ?? box.width) * widget.focusDiameterFraction;

          return Stack(
            children: [
              Positioned.fill(
                child: Image(image: widget.background, fit: BoxFit.cover),
              ),
              Positioned(
                left: center.dx - diameter / 2,
                top: center.dy - diameter / 2,
                width: diameter,
                height: diameter,
                child: DecoratedBox(
                  key: _targetKey,
                  decoration: widget.showFocusRing
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFF2D6B),
                            width: 3,
                          ),
                        )
                      : const BoxDecoration(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// [BoxFit.cover] で [box] を覆ったときの、画像が実際に描画される矩形。
Rect? _coverRect(Size? image, Size box) {
  if (image == null || image.isEmpty || box.isEmpty) return null;
  final scale = math.max(box.width / image.width, box.height / image.height);
  final w = image.width * scale;
  final h = image.height * scale;
  return Rect.fromLTWH((box.width - w) / 2, (box.height - h) / 2, w, h);
}

class _ProfilePopup extends StatelessWidget {
  const _ProfilePopup({required this.profile});

  final SpeakerProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 460),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image(
              image: profile.avatar,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  profile.tagline,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('🐦', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      profile.snsHandle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
