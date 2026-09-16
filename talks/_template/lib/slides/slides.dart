import 'package:flutter_deck/flutter_deck.dart';
import 'package:slide_kit/slide_kit.dart';

import 'src/closing_slide.dart';
import 'src/section_slide.dart';
import 'src/title_slide.dart';

/// この登壇のスライド一覧。上から順に表示される。
List<FlutterDeckSlideWidget> get slides => [
      const TitleSlide(),
      // 共通部品の自己紹介スライド（プロフィールは差し替え可）
      WhoAmISlide(),
      const SectionSlide(),
      const ClosingSlide(),
    ];
