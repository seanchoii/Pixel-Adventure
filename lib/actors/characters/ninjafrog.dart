import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/actors/utils/audiomanager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum Frog { nfRun }

// this class represents Ninja Frog character in Select Character page
class NinjaFrog extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  // local variable
  double stepTime = 0.05;
  // constructor
  NinjaFrog({size, position}) : super(size: size, position: position) {}
  late final SpriteAnimation run;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    super.onLoad();
  }

  // loading all animations
  void _loadAllAnimation() {
    run = SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/Ninja Frog/Run (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: 12, stepTime: stepTime, textureSize: Vector2.all(32)));
    current = Frog.nfRun;
    animations = {Frog.nfRun: run}; // update
  }

  // actions to be performed if clicked
  @override
  void onTapDown(TapDownEvent event) {
    gameRef.playerName = 'Ninja Frog'; // character selected
    gameRef.loadLevel('Level-01.tmx'); // level 1 start
    AudioManager.playBgm('bgm.mp3');

    super.onTapDown(event);
  }
}
