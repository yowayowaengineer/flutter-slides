import 'package:flutter/material.dart';
import 'package:slide_kit/slide_kit.dart';

import 'slides/slides.dart';

void main() {
  runApp(
    SlideDeckApp(
      slides: slides,
      // LT の持ち時間 5 分で 1 往復する。2 枚目に進んだ時点から歩き出し、
      // 1 枚目に戻ると時計はリセットされる。
      footer: const WalkingFooter(lapDuration: Duration(minutes: 5)),
    ),
  );
}
