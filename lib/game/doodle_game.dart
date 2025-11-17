import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ignite_hop/game/components/player.dart';
import 'package:ignite_hop/game/components/platform.dart';
import 'package:ignite_hop/game/managers/platform_manager.dart';

class DoodleGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  late Player player;
  late CameraComponent cameraComponent;
  late PlatformManager platformManager;

  Function(int)? onScoreUpdate;
  Function()? onGameOver;

  int score = 0;
  double highestY = 700;
  bool gameStarted = false;

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    platformManager = PlatformManager();
    platformManager.generateInitialPlatforms();

    for (var platform in platformManager.platforms) {
      add(platform);
    }

    player = Player(position: Vector2(200, 650));
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameStarted) return;

    if (player.position.y < highestY) {
      final scoreDiff = ((highestY - player.position.y) / 10).floor();
      score += scoreDiff;
      highestY = player.position.y;
      onScoreUpdate?.call(score);
    }

    final cameraY = player.position.y;
    camera.viewfinder.position = Vector2(200, cameraY);

    platformManager.generatePlatform(cameraY);
    platformManager.cleanupPlatforms(cameraY);

    final newPlatforms = platformManager.platforms
        .where((p) => !children.contains(p))
        .toList();
    for (var platform in newPlatforms) {
      add(platform);
    }

    children.whereType<Platform>().forEach((platform) {
      if (!platformManager.platforms.contains(platform)) {
        platform.removeFromParent();
      }
    });

    if (player.position.y > cameraY + 450) {
      gameOver();
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!gameStarted) {
      startGame();
    }
  }

  void startGame() {
    gameStarted = true;
    score = 0;
    highestY = player.position.y;
    player.velocity.y = Player.jumpVelocity;
  }

  void gameOver() {
    gameStarted = false;
    onGameOver?.call();
    pauseEngine();
  }

  void resetGame() {
    score = 0;
    highestY = 700;
    gameStarted = false;

    player.position = Vector2(200, 650);
    player.velocity = Vector2.zero();
    player.isJumping = false;

    camera.viewfinder.position = Vector2(200, 700);

    children.whereType<Platform>().forEach((platform) {
      platform.removeFromParent();
    });

    platformManager.generateInitialPlatforms();
    for (var platform in platformManager.platforms) {
      add(platform);
    }

    resumeEngine();
  }
}
