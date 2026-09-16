import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

/// slide_kit にバンドルされたアセット。
const _package = 'slide_kit';

/// フッターに置くロゴの左を、キャラクターが左右に歩き続けるエフェクト。
///
/// 既定では slide_kit 同梱のドット絵キャラクターとロゴを使う。
/// 登壇ごとに差し替えたいときは各 [ImageProvider] を渡す。
///
/// flutter_deck の [FlutterDeckFooterConfiguration.widget] に渡して使う。
/// 2 枚目のスライド以降でアニメーションが始まる（タイトルでは静止）。
class WalkingFooter extends StatefulWidget {
  const WalkingFooter({
    super.key,
    this.logo = const AssetImage(
      'assets/images/logo_512x512.png',
      package: _package,
    ),
    this.idleFrame = const AssetImage(
      'assets/images/player-idle.png',
      package: _package,
    ),
    this.walkFrames = const [
      AssetImage('assets/images/player-walk-left.gif', package: _package),
      AssetImage('assets/images/player-walk-right.gif', package: _package),
    ],
    this.lapDuration = const Duration(minutes: 20),
    this.characterSize = 50,
    this.logoSize = 40,
  });

  /// フッター中央に表示するロゴ。
  final ImageProvider logo;

  /// 歩き出す前（タイトルスライド）の静止フレーム。
  final ImageProvider idleFrame;

  /// 歩行アニメーションのフレーム（左向き・右向きを交互に切り替える）。
  final List<ImageProvider> walkFrames;

  /// 画面を 1 往復するのにかける時間。
  final Duration lapDuration;

  /// 歩くキャラクターの表示サイズ。
  final double characterSize;

  /// 中央ロゴの表示サイズ。
  final double logoSize;

  @override
  State<WalkingFooter> createState() => _WalkingFooterState();
}

class _WalkingFooterState extends State<WalkingFooter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isMovingRight = false;
  int _frameIndex = 0;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.lapDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.addListener(() {
      final wasMovingRight = _isMovingRight;
      _isMovingRight = _animation.value >= 0.5;
      if (wasMovingRight != _isMovingRight && mounted) {
        setState(() {
          _frameIndex = (_frameIndex + 1) % widget.walkFrames.length;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 2 枚目以降のスライドに入ったら歩き始める。
    if (!_started && mounted) {
      final slideIndex = context.flutterDeck.router.currentSlideIndex;
      if (slideIndex >= 1) {
        _started = true;
        _controller.repeat();
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterSize = widget.characterSize;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final footerTop = screenHeight * 0.89;
    const logoPosition = 100.0;
    const rightMargin = 100.0;
    final rightEndPosition = screenWidth - rightMargin;
    final travel = rightEndPosition - logoPosition + characterSize;

    return UnconstrainedBox(
      constrainedAxis: Axis.horizontal,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Image(
                image: widget.logo,
                width: widget.logoSize,
                height: widget.logoSize,
                fit: BoxFit.contain,
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final double position;
                if (!_started) {
                  position = rightEndPosition;
                } else if (_animation.value <= 0.5) {
                  final progress = _animation.value * 2.0;
                  position = rightEndPosition - travel * progress;
                } else {
                  final progress = (_animation.value - 0.5) * 2.0;
                  position = logoPosition - characterSize + travel * progress;
                }

                final frame = _started
                    ? widget.walkFrames[_frameIndex]
                    : widget.idleFrame;

                return Positioned(
                  left: position,
                  top: footerTop - (screenHeight * 0.9),
                  child: Image(
                    image: frame,
                    width: characterSize,
                    height: characterSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => SizedBox(
                      width: characterSize,
                      height: characterSize,
                      child: Container(
                        color: Colors.grey.withValues(alpha: 0.3),
                        child: const Icon(Icons.image, size: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
