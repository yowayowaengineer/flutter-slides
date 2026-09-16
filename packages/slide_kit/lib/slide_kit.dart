/// 登壇資料の共通部品パッケージ。
///
/// - [SlideDeckApp]: 各登壇アプリのルート（テーマ・歩くフッター込み）
/// - [WalkingFooter]: フッターを歩くドット絵キャラクター
/// - [WhoAmISlide] / [SpeakerProfile]: 自己紹介スライドとプロフィール
/// - [AppColors] / [SlideTheme]: 共通テーマ
library;

export 'src/app/slide_deck_app.dart';
export 'src/footer/walking_footer.dart';
export 'src/model/speaker_profile.dart';
export 'src/slides/who_am_i_slide.dart';
export 'src/theme/app_colors.dart';
export 'src/theme/slide_theme.dart';
