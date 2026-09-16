import 'package:flutter/widgets.dart';

/// 自己紹介スライドなどで使う登壇者プロフィール。
///
/// 既定値 [SpeakerProfile.yowayowa] を使うか、登壇ごとに差し替える。
@immutable
class SpeakerProfile {
  const SpeakerProfile({
    required this.name,
    required this.tagline,
    required this.snsHandle,
    required this.avatar,
    this.snsUrl,
    this.links = const [],
  });

  /// 表示名。例: `よわよわエンジニア`
  final String name;

  /// 肩書き・ひとこと。例: `🍩☕ 岡山.Flutter 主宰`
  final String tagline;

  /// SNS ハンドル。例: `@yowayowa_engr`
  final String snsHandle;

  /// SNS ハンドルのリンク先（省略可）。
  final String? snsUrl;

  /// アイコン画像。パッケージ内アセットなら `AssetImage(..., package: 'slide_kit')`。
  final ImageProvider avatar;

  /// 追加リンク（GitHub / ブログなど）。
  final List<SpeakerLink> links;

  SpeakerProfile copyWith({
    String? name,
    String? tagline,
    String? snsHandle,
    String? snsUrl,
    ImageProvider? avatar,
    List<SpeakerLink>? links,
  }) {
    return SpeakerProfile(
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      snsHandle: snsHandle ?? this.snsHandle,
      snsUrl: snsUrl ?? this.snsUrl,
      avatar: avatar ?? this.avatar,
      links: links ?? this.links,
    );
  }

  /// 既定の登壇者プロフィール（よわよわエンジニア）。
  static const SpeakerProfile yowayowa = SpeakerProfile(
    name: 'よわよわエンジニア',
    tagline: '🍩☕ 岡山.Flutter 主宰',
    snsHandle: '@yowayowa_engr',
    snsUrl: 'https://x.com/yowayowa_engr',
    avatar: AssetImage('assets/images/me_400x400.jpg', package: 'slide_kit'),
  );
}

/// プロフィールに載せる外部リンク。
@immutable
class SpeakerLink {
  const SpeakerLink({
    required this.label,
    required this.url,
    this.emoji,
  });

  final String label;
  final String url;
  final String? emoji;
}
