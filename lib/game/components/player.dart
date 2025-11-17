import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:ignite_hop/game/components/platform.dart';
import 'package:ignite_hop/game/doodle_game.dart';

class Player extends PositionComponent with CollisionCallbacks, HasGameRef<DoodleGame> {
  static const double gravity = 800.0;
  static const double jumpVelocity = -600.0;
  static const double maxFallSpeed = 800.0;

  Vector2 velocity = Vector2.zero();
  bool isJumping = false;

  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity.y += gravity * dt;

    if (velocity.y > maxFallSpeed) {
      velocity.y = maxFallSpeed;
    }

    position += velocity * dt;

    if (position.x < 20) position.x = 20;
    if (position.x > 380) position.x = 380;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bodyPaint = Paint()
      ..color = const Color(0xFFFF6B9D)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      bodyPaint,
    );

    final eyePaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.x / 2 - 8, size.y / 2 - 5), 4, eyePaint);
    canvas.drawCircle(Offset(size.x / 2 + 8, size.y / 2 - 5), 4, eyePaint);

    final mouthPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final mouthPath = Path()
      ..moveTo(size.x / 2 - 8, size.y / 2 + 5)
      ..quadraticBezierTo(
        size.x / 2,
        size.y / 2 + 10,
        size.x / 2 + 8,
        size.y / 2 + 5,
      );

    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Platform && velocity.y > 0) {
      if (other.isBroken) return;

      velocity.y = jumpVelocity;
      isJumping = true;

      // Notify game for optional side-effects (e.g., haptics)
      gameRef.onPlayerBounce?.call();

      other.breakPlatform();
    }
  }

  void jump() {
    if (!isJumping) {
      velocity.y = jumpVelocity;
      isJumping = true;
    }
  }

  void moveLeft() {
    position.x -= 5;
  }

  void moveRight() {
    position.x += 5;
  }
}
