import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/speaker_profile.dart';
import '../theme/app_colors.dart';

/// 登壇者の自己紹介スライド。
///
/// プロフィールは [SpeakerProfile] で差し替え可能。既定は
/// [SpeakerProfile.yowayowa]。
class WhoAmISlide extends FlutterDeckSlideWidget {
  WhoAmISlide({
    super.key,
    this.profile = SpeakerProfile.yowayowa,
    this.title = '👋 よわよわエンジニア is 誰',
    String route = '/who-am-i',
  }) : super(
          configuration: FlutterDeckSlideConfiguration(
            route: route,
            header: FlutterDeckHeaderConfiguration(title: title),
          ),
        );

  final SpeakerProfile profile;
  final String title;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => Center(
        child: _ProfileCard(profile: profile),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final SpeakerProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: Image(
              image: profile.avatar,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deckText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.tagline,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 20),
                _LinkChip(
                  emoji: '🐦',
                  label: profile.snsHandle,
                  url: profile.snsUrl,
                ),
                for (final link in profile.links) ...[
                  const SizedBox(height: 8),
                  _LinkChip(
                    emoji: link.emoji,
                    label: link.label,
                    url: link.url,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.label, this.emoji, this.url});

  final String label;
  final String? emoji;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (emoji != null) ...[
          Text(emoji!, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.blue,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );

    if (url == null) return content;

    return InkWell(
      onTap: () => launchUrl(Uri.parse(url!)),
      child: content,
    );
  }
}
