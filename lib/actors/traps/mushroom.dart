import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/hud/hud.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import '../utils/audiomanager.dart';

// enum containing different animations of mushroom
enum MushroomType { run }

// this class contains components of enemies
class Mushroom extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  // local variable
  double stepTime = 0.1;
  Vector2 targetPosition;
  Vector2 spawn;
  // constructor
  Mushroom({position, size, required this.targetPosition, required this.spawn})
      : super(size: size, position: position) {
    add(
      MoveToEffect(
        Vector2(targetPosition.x, position.y),
        EffectController(alternate: true, infinite: true, speed: 150),
      ),
    );
  }
  late final SpriteAnimation mushRun;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
        size: Vector2(30, 20), position: Vector2(0, 10))); // hitbox selected
    _loadAllAnimation();
    return super.onLoad();
  }

  // loading all animations of enemies
  void _loadAllAnimation() {
    mushRun = _enemyDisplay('Run', 16);
    current = MushroomType.run;
    // updating enum enemies
    animations = {MushroomType.run: mushRun};
  }

  // fetching images and creating animations
  SpriteAnimation _enemyDisplay(String status, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Enemies/Mushroom/$status (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  // if collides with a player
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      final playerDir = (other.absoluteCenter - absoluteCenter)
          .normalized(); // distance between player bottom and mushroom top
      // if player steps on the mushroom, the mush room is removed
      if (playerDir.dot(Vector2(0, -1)) > 0.7) {
        add(RemoveEffect());
      } else {
        gameRef.playerStats.lives.value -= 1;
        other.position = Vector2(
            10000, 10000); // travel to a random location where its not visible
        // the player is dead
        if (gameRef.playerStats.lives.value < 1) {
          Future.delayed(const Duration(milliseconds: 500), () {
            AudioManager.stopBgm();
            gameRef.loadLevel('GameOver.tmx'); // gameover page
            gameRef.add(Hud());
            gameRef.add(gameRef.gameOverText);
          });
        } else {
          AudioManager.playSfx('hit.wav', 0.4);
          Future.delayed(const Duration(seconds: 2), () {
            other.respawn(); // respawn effect
          });
        }
      }
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
