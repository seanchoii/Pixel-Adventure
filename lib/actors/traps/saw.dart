import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// enum containing different animations of saw (for now only one)
enum SawType { On }

// this class contains components of saw
class Saw extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  // local variable
  double stepTime = 0.05;
  Vector2 targetPosition;
  Vector2 spawn;
  // constructor
  Saw({position, size, required this.targetPosition, required this.spawn})
      : super(size: size, position: position) {
    add(
      MoveToEffect(
        Vector2(spawn.x, targetPosition.y),
        EffectController(alternate: true, infinite: true, speed: 90),
      ),
    );
  }
  late final SpriteAnimation sawOn;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(size: Vector2.all(38)));
    _loadAllAnimation();
    return super.onLoad();
  }

  // loading all animations of enemies
  void _loadAllAnimation() {
    sawOn = _enemyDisplay('On', 8);
    current = SawType.On;
    // updating enum enemies
    animations = {SawType.On: sawOn};
  }

  // fetching images and creating animations
  SpriteAnimation _enemyDisplay(String status, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/$status (38x38).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(38)));
  }
}
