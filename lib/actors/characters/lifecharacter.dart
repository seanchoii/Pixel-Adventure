import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum Character { idleState }

// this class represents Maskdude character in Select Character page
class LifeCharacter extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  // local variable
  double stepTime = 0.1;
  String character;
  // constructor
  LifeCharacter({size, position, required this.character})
      : super(size: size, position: position) {}
  late final SpriteAnimation characterAnimation;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    characterAnimation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/Idle (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: 11, stepTime: stepTime, textureSize: Vector2.all(32)));
    current = Character.idleState;
    animations = {Character.idleState: characterAnimation}; // update
  }
}
