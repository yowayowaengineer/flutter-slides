import 'package:flutter/material.dart';
import 'package:slide_kit/slide_kit.dart';

/// スクショ差し込み枠。あとで実画像に差し替える。
class ScreenshotPlaceholder extends StatelessWidget {
  const ScreenshotPlaceholder(this.label, {super.key, this.accent = AppColors.blue});

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
    required this.shotLabel,
    this.accent = AppColors.pink,
  });

  final String symptom;
  final String errorText;
  final String shotLabel;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(symptom, style: SlideTextStyles.body.copyWith(fontSize: 34)),
        const SizedBox(height: SlideSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(SlideSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFF3A0D0D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEF5350).withValues(alpha: 0.6)),
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
    );
  }
}
