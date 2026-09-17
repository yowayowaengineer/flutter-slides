/// 登壇資料の共通部品パッケージ。
///
/// - [SlideDeckApp]: 各登壇アプリのルート（テーマ・歩くフッター込み）
/// - [WalkingFooter]: フッターを歩くドット絵キャラクター
/// - [WhoAmISlide] / [SpeakerProfile]: 自己紹介スライドとプロフィール
/// - レイアウト部品: [TitleLayout] / [SectionDividerLayout] / [BigMessageLayout]
///   / [BulletLayout] / [AgendaLayout] / [TwoColumnLayout] / [ComparisonLayout]
///   / [CardsLayout] / [QuoteLayout] / [CodeLayout] / [CaptionedImageLayout]
/// - [SlideContentX.asSlide]: レイアウトをフッター付きスライドに変換
/// - デザイントークン: [AppColors] / [SlideTheme] / [SlideTextStyles] /
///   [SlideSpacing] / [SlideDecoration]
library;

export 'src/app/slide_deck_app.dart';
export 'src/design/slide_tokens.dart';
export 'src/footer/walking_footer.dart';
export 'src/layouts/content_layouts.dart';
export 'src/layouts/content_slide.dart';
export 'src/layouts/heading_layouts.dart';
export 'src/layouts/media_layouts.dart';
export 'src/model/speaker_profile.dart';
export 'src/slides/who_am_i_slide.dart';
export 'src/theme/app_colors.dart';
export 'src/theme/slide_theme.dart';
