import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum type_ { chain, ball }

class SpikeBall extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  bool isSpikeBall;
  SpikeBall({size, position, this.isSpikeBall = false})
      : super(size: size, position: position) {}
  late final SpriteAnimation chains;
  late final SpriteAnimation spikedBall;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    loadAnimation();
    if (isSpikeBall) {
      current = type_.ball;
    } else {
      current = type_.chain;
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    //updateMovement(dt);
    super.update(dt);
  }

  void updateMovement(double dt) {
    velocity.x = -5;
    position.x += velocity.x * dt;
    position.y += -5 * dt;
  }

  void loadAnimation() {
    spikedBall = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Spiked Ball/Spiked Ball.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.05, textureSize: Vector2.all(28)));
    chains = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/Chain.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.05, textureSize: Vector2.all(8)));

    animations = {type_.chain: chains, type_.ball: spikedBall};
  }
}
