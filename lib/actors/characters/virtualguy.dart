import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import '../utils/audiomanager.dart';

enum vg { vgRun }

// this class represents virtual guy in selecte character page
class VirtualGuy extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  // local variable
  double stepTime = 0.05;
  // constructor
  VirtualGuy({size, position}) : super(size: size, position: position) {}
  late final SpriteAnimation run;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    run = SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/Virtual Guy/Run (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: 12, stepTime: stepTime, textureSize: Vector2.all(32)));
    current = vg.vgRun;
    animations = {vg.vgRun: run}; // update
  }

  // actions to be performed if clicked
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.playerName = 'Virtual Guy'; // virtual guy selected
    gameRef.loadLevel('Level-01.tmx'); // level 1 start
    AudioManager.playBgm('bgm.mp3');

    super.onTapDown(event);
  }
}
