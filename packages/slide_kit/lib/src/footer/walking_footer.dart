import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_deck/flutter_deck.dart';

/// slide_kit にバンドルされたアセット。
const _package = 'slide_kit';

/// 歩き始めた時刻の保持場所。
///
/// flutter_deck はスライド 1 枚ごとに独立したルートを作り、フッターも各スライド
/// の中に置かれる。そのためスライドを送るたびに [WalkingFooter] の State は
/// 作り直される。進行状況を State に持たせると毎回 0 に戻ってしまうので、
/// 開始時刻だけをここに逃がし、位置は「開始からの実経過時間」で計算する。
class _WalkClock {
  const _WalkClock._();

  static DateTime? _startedAt;

  static DateTime? get startedAt => _startedAt;

  /// まだ歩き出していなければ、いまを開始時刻にする。
  static void startIfNeeded() => _startedAt ??= DateTime.now();

  /// 開始時刻を捨てて、次に歩き出すときを 0 に戻す。
  static void reset() => _startedAt = null;
}

/// フッターに置くロゴの左を、キャラクターが左右に歩き続けるエフェクト。
///
/// 既定では slide_kit 同梱のドット絵キャラクターとロゴを使う。
/// 登壇ごとに差し替えたいときは各 [ImageProvider] を渡す。
///
/// flutter_deck の [FlutterDeckFooterConfiguration.widget] に渡して使う。
///
/// ## 進み方
///
/// 位置は「歩き始めてからの実経過時間」で決まるので、スライドを送っても
/// 続きから歩く。[lapDuration] を登壇時間に合わせると、キャラクターの位置が
/// そのまま経過時間の目安になる。
///
/// 片道（右端 → 左端）を登壇時間に合わせたい場合は、[lapDuration] に登壇時間の
/// 2 倍を渡す。左端に着いた時点が持ち時間の終わり、という読み方ができる。
///
/// 1 枚目のスライドでは歩かない（登壇開始前に出しっぱなしにすることが多いため）。
/// また 1 枚目に戻ると時計はリセットされ、次のスライドへ進んだ時点で
/// あらためて 0 から歩き出す。
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

  /// 歩き出す前（1 枚目のスライド）の静止フレーム。
  final ImageProvider idleFrame;

  /// 歩行アニメーションのフレーム。`[左へ歩く絵, 右へ歩く絵]` の順。
  final List<ImageProvider> walkFrames;

  /// 画面を 1 往復（右端 → 左端 → 右端）するのにかける時間。
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
  /// 1 往復を 0..1 で表した進み具合。0 と 1 が右端、0.5 が左端。
  final ValueNotifier<double> _phase = ValueNotifier(0);
  late final Ticker _ticker;
  bool _walking = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 1 枚目にいるかどうかで、歩く / 止まる＋リセット を切り替える。
    final isFirstSlide = context.flutterDeck.router.currentSlideIndex == 0;

    if (isFirstSlide) {
      _WalkClock.reset();
      _setWalking(false);
    } else {
      _WalkClock.startIfNeeded();
      _setWalking(true);
    }
  }

  void _setWalking(bool value) {
    if (_walking == value) return;
    _walking = value;
    if (value) {
      _ticker.start();
    } else {
      _ticker.stop();
      _phase.value = 0;
    }
    // 静止フレームと歩行フレームの切り替えのために作り直す。
    if (mounted) setState(() {});
  }

  void _onTick(Duration _) {
    final startedAt = _WalkClock.startedAt;
    final lapMs = widget.lapDuration.inMilliseconds;
    if (startedAt == null || lapMs <= 0) return;

    final elapsed = DateTime.now().difference(startedAt).inMilliseconds;
    _phase.value = (elapsed % lapMs) / lapMs;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _phase.dispose();
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
            ValueListenableBuilder<double>(
              valueListenable: _phase,
              builder: (context, phase, child) {
                // 前半（0..0.5）は右端から左端へ、後半は左端から右端へ。
                final goingLeft = phase <= 0.5;
                final double position;
                if (!_walking) {
                  position = rightEndPosition;
                } else if (goingLeft) {
                  position = rightEndPosition - travel * (phase * 2.0);
                } else {
                  position = logoPosition -
                      characterSize +
                      travel * ((phase - 0.5) * 2.0);
                }

                final frame = _walking
                    ? widget.walkFrames[goingLeft ? 0 : 1]
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
