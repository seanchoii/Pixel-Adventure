import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// enum containing different animations of radish
enum RadishType { run }

// this class contains components of enemies
class Radish extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  // local variable
  double stepTime = 0.05;
  Vector2 targetPosition;
  Vector2 spawn;
  // constructor
  Radish({position, size, required this.targetPosition, required this.spawn})
      : super(size: size, position: position) {
    if (position != null) {
      // Need to sequence two move to effects so that we can
      // tap into the onFinishCallback and flip the component.
      final effect = SequenceEffect(
        [
          MoveToEffect(
            Vector2(targetPosition.x, position.y),
            EffectController(speed: 175),
            onComplete: () => flipHorizontallyAroundCenter(),
          ),
          MoveToEffect(
            position + Vector2(32, 0), // Need to offset by 32 due to flip
            EffectController(speed: 175),
            onComplete: () => flipHorizontallyAroundCenter(),
          ),
        ],
        infinite: true,
      );

      add(effect);
    }
  }
  late final SpriteAnimation radishRun;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(size: Vector2(30, 20), position: Vector2(0, 10)));
    _loadAllAnimation();
    return super.onLoad();
  }

  // loading all animations of enemies
  void _loadAllAnimation() {
    radishRun = _enemyDisplay('Run', 12);
    current = RadishType.run;
    // updating enum enemies
    animations = {RadishType.run: radishRun};
  }

  // fetching images and creating animations
  SpriteAnimation _enemyDisplay(String status, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Enemies/Radish/$status (30x38).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2(30, 38)));
  }
}
