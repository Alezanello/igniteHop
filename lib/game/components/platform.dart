import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

enum PlatformType { normal, moving, fragile }

class Platform extends PositionComponent with CollisionCallbacks {
  final PlatformType type;
  final double speed;
  bool isBroken = false;
  double direction = 1;

  Platform({
    required Vector2 position,
    required this.type,
    this.speed = 100.0,
  }) : super(
          position: position,
          size: Vector2(80, 15),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (type == PlatformType.moving && !isBroken) {
      position.x += speed * direction * dt;

      if (position.x <= 40 || position.x >= 360) {
        direction *= -1;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isBroken) return;

    final paint = Paint();

    switch (type) {
      case PlatformType.normal:
        paint.color = const Color(0xFF4CAF50);
        break;
      case PlatformType.moving:
        paint.color = const Color(0xFF2196F3);
        break;
      case PlatformType.fragile:
        paint.color = const Color(0xFF795548);
        break;
    }

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rrect, paint);

    paint.color = const Color(0xFFFFFFFF).withValues(alpha: 0.3);
    final highlightRect = Rect.fromLTWH(5, 2, size.x - 10, 5);
    final highlightRRect =
        RRect.fromRectAndRadius(highlightRect, const Radius.circular(4));
    canvas.drawRRect(highlightRRect, paint);
  }

  void breakPlatform() {
    if (type == PlatformType.fragile) {
      isBroken = true;
    }
  }
}
