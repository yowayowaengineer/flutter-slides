import 'package:flutter/material.dart';
import 'package:slide_kit/slide_kit.dart';

import 'slides.dart';

/// slide_kit のレイアウト部品を一覧するカタログ登壇。
/// デザイン確認用: `fvm flutter run -d chrome`
void main() {
  runApp(SlideDeckApp(slides: gallerySlides));
}
