import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/hud/hud.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import '../utils/audiomanager.dart';

enum mask { maskDude }

// this class represents Maskdude character in Select Character page
class MaskDude extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  // local variable
  double stepTime = 0.05;
  // constructor
  MaskDude({size, position}) : super(size: size, position: position) {}
  late final SpriteAnimation run;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    run = SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/Mask Dude/Run (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: 12, stepTime: stepTime, textureSize: Vector2.all(32)));
    current = mask.maskDude;
    animations = {mask.maskDude: run}; // update
  }

  // actions to be performed if clicked
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.playerName = 'Mask Dude'; // character selected
    gameRef.loadLevel('Level-01.tmx'); // level 1 start
    gameRef.add(Hud()); // add hud
    gameRef.selectCharacterText.removeFromParent();
    AudioManager.playBgm('bgm.mp3');

    super.onTapDown(event);
  }
}
