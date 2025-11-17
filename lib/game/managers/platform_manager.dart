import 'dart:math';
import 'package:flame/components.dart';
import 'package:ignite_hop/game/components/platform.dart';

class PlatformManager extends Component {
  final Random _random = Random();
  final List<Platform> platforms = [];
  double highestPlatformY = 700;
  final double screenWidth = 400;
  final double screenHeight = 800;

  void generateInitialPlatforms() {
    platforms.clear();

    for (int i = 0; i < 10; i++) {
      final x = _random.nextDouble() * (screenWidth - 100) + 50;
      final y = 700 - (i * 80.0);

      platforms.add(
        Platform(
          position: Vector2(x, y),
          type: PlatformType.normal,
        ),
      );
    }

    highestPlatformY = platforms.last.position.y;
  }

  void generatePlatform(double cameraY) {
    while (highestPlatformY > cameraY - screenHeight) {
      final x = _random.nextDouble() * (screenWidth - 100) + 50;
      final y = highestPlatformY - (60 + _random.nextDouble() * 40);

      PlatformType type = PlatformType.normal;
      final typeRoll = _random.nextDouble();

      if (typeRoll < 0.2) {
        type = PlatformType.moving;
      } else if (typeRoll < 0.35) {
        type = PlatformType.fragile;
      }

      platforms.add(
        Platform(
          position: Vector2(x, y),
          type: type,
          speed: type == PlatformType.moving ? 50 + _random.nextDouble() * 50 : 0,
        ),
      );

      highestPlatformY = y;
    }
  }

  void cleanupPlatforms(double cameraY) {
    platforms.removeWhere((platform) => platform.position.y > cameraY + 100);
  }
}
