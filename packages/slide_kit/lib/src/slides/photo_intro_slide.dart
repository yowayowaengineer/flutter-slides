import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../model/speaker_profile.dart';

/// 写真＋タップ演出の自己紹介スライド。
///
/// 背景いっぱいのイベント写真を表示し、写真内の顔の位置（[focusPosition]）を
/// タップするとスポットライト＋プロフィールカードがポップする。
///
/// 既定は FlutterKaigi2025 の写真＋[SpeakerProfile.yowayowa]。登壇ごとに
/// [background] と [focusPosition] を差し替える。座標は 1920x1080 基準。
class PhotoIntroSlide extends FlutterDeckSlideWidget {
  PhotoIntroSlide({
    super.key,
    this.profile = SpeakerProfile.yowayowa,
    this.background = const AssetImage(
      'assets/images/FlutterKaigi2025.webp',
      package: 'slide_kit',
    ),
    this.focusPosition = const Offset(967, 528),
    this.focusSize = 40,
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

  /// スポットライトを当てる位置（1920x1080 基準の座標）。
  final Offset focusPosition;

  /// スポットライトの直径。
  final double focusSize;

  final String title;

  @override
  FlutterDeckSlide build(BuildContext context) {
    final targetKey = GlobalKey();

    void showTutorial() {
      TutorialCoachMark(
        targets: [
          TargetFocus(
            identify: 'speaker',
            keyTarget: targetKey,
            shape: ShapeLightFocus.Circle,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                builder: (context, controller) =>
                    _ProfilePopup(profile: profile),
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

    return FlutterDeckSlide.blank(
      builder: (context) => GestureDetector(
        onTap: showTutorial,
        child: Stack(
          children: [
            Image(
              image: background,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              left: focusPosition.dx.w,
              top: focusPosition.dy.h,
              child: SizedBox(
                key: targetKey,
                width: focusSize.w,
                height: focusSize.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
