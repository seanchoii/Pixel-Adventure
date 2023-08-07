import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/actors/utils/audiomanager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum Buttons { volume }

// this class contains component of restart button
class Volume extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  // constructor
  Volume({size, position}) : super(size: size, position: position) {}
  late final SpriteAnimation volumeButton;
  bool soundTurnedOff = false;
  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    volumeButton = SpriteAnimation.fromFrameData(
        game.images.fromCache('Menu/Buttons/Volume.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(21, 22)));
    current = Buttons.volume;
    animations = {Buttons.volume: volumeButton}; // update
  }

  // if tapped, reset to select character page
  @override
  void onTapDown(TapDownEvent event) {
    if (!soundTurnedOff) {
      AudioManager.stopBgm();
      soundTurnedOff = true;
    } else if (soundTurnedOff) {
      AudioManager.resumeBgm();
      soundTurnedOff = false;
    }

    super.onTapDown(event);
  }
}
