import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// enum containing different animations of rockhead
enum RockheadType { blink }

// this class contains components of enemies
class Rockhead extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  // local variable
  double stepTime = 0.3;
  Vector2 targetPosition;
  Vector2 spawn;
  // constructor
  Rockhead({position, size, required this.targetPosition, required this.spawn})
      : super(size: size, position: position) {
    add(
      MoveToEffect(
        Vector2(targetPosition.x, position.y),
        EffectController(alternate: true, infinite: true, speed: 150),
      ),
    );
  }
  late final SpriteAnimation rockHead;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(size: Vector2.all(32), position: Vector2(5, 6)));
    _loadAllAnimation();
    return super.onLoad();
  }

  // loading all animations of enemies
  void _loadAllAnimation() {
    rockHead = _enemyDisplay('Blink', 4);
    current = RockheadType.blink;
    // updating enum enemies
    animations = {
      RockheadType.blink: rockHead,
    };
  }

  // fetching images and creating animations
  SpriteAnimation _enemyDisplay(String status, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Rock Head/$status (42x42).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(42)));
  }
}
