import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/hud/hud.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// enum containng different animations of checkpoints
enum checkpoints { end2 }

// this class contains components of checkpoints
class CheckPoint extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameRef<PixelAdventure> {
  // local variable
  Function? onPlayerEnter;
  String checkpoint;
  double stepTime = 0.05;
  final int score = 0;
  // constructor
  CheckPoint(
      {required this.checkpoint, size, required position, this.onPlayerEnter})
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
    end = _checkPointDisplay(checkpoint, 10);

    current = checkpoints.end2;
    animations = {checkpoints.end2: end}; // update
  }

  // fetching images and creating animations
  SpriteAnimation _checkPointDisplay(String checkpoint, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/$checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(64)));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // if it collides with a player object
    if (other is Player) {
      add(RemoveEffect()); // remove effect
      gameRef.playerStats.level.value += 1;
      onPlayerEnter?.call(); // custom function call
      gameRef.add(Hud()); // adding hud back to the game
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
