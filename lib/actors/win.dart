import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/hud/hud.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// enum containng different animations of checkpoints
enum win { winEnding }

// this class contains components of winning trophy
class Win extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameRef<PixelAdventure> {
  // local variable
  Function? onPlayerEnter;
  double stepTime = 0.05;
  final int score = 0;
  // constructor
  Win({size, required position, this.onPlayerEnter})
      : super(size: size, position: position) {}
  late final SpriteAnimation end;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    add(RectangleHitbox(size: Vector2(30, 50), position: Vector2(18, 10))
      ..collisionType = CollisionType
          .passive); // passive collision type = collides with other collidables of type active
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    end = _checkPointDisplay('End', 1);

    current = win.winEnding;
    animations = {win.winEnding: end}; // update
  }

  // fetching images and creating animations
  SpriteAnimation _checkPointDisplay(String checkpoint, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Checkpoints/End/$checkpoint (Idle).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(64)));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // if it collides with a player object
    if (other is Player) {
      add(RemoveEffect()); // remove effect
      onPlayerEnter?.call(); // custom function call
      gameRef.add(Hud()); // adding hud back to the game
      gameRef.add(gameRef.winText);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
