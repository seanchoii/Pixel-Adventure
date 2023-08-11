import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/actors/utils/audiomanager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum Buttons { restart }

// this class contains component of restart button
class Restart extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  // constructor
  Restart({size, position}) : super(size: size, position: position) {}
  late final SpriteAnimation restartButton;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    restartButton = SpriteAnimation.fromFrameData(
        game.images.fromCache('Menu/Buttons/Restart.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(21, 22)));
    current = Buttons.restart;
    animations = {Buttons.restart: restartButton}; // update
  }

  // if tapped, reset to select character page
  @override
  void onTapDown(TapDownEvent event) {
    AudioManager.stopBgm();
    gameRef.loadLevel('Start.tmx');
    // reset to default settings
    gameRef.playerStats.level.value = 1;
    gameRef.playerStats.lives.value = 5;
    gameRef.playerStats.score.value = 0;
    super.onTapDown(event);
  }
}
