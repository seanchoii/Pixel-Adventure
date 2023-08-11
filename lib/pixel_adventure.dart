import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/actors/utils/player_stats.dart';
import 'package:pixel_adventure/level/level.dart';

import 'actors/utils/audiomanager.dart';

// this class is the main class that adds all components
class PixelAdventure extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() =>
      const Color(0xFF211F30); // setting corners the same colour
  Level? currentLevel;
  CameraComponent? cam; // camera
  String playerName = 'Mask Dude';
  final playerStats = PlayerStats(); // player stats
  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    await AudioManager.init();
    loadLevel('Start.tmx'); // load level
    // setting camera
    cam = CameraComponent.withFixedResolution(
        world: currentLevel!, width: 640, height: 360);
    cam!.viewfinder.anchor = Anchor.topLeft;
    await add(cam!);

    return super.onLoad();
  }

  // method that loads level accordingly
  void loadLevel(String levelName) {
    currentLevel?.removeFromParent(); // removing current level
    currentLevel =
        Level(levelName: levelName, playerName: playerName); // new level loaded
    cam = CameraComponent.withFixedResolution(
        world: currentLevel!, width: 640, height: 360);
    cam!.viewfinder.anchor = Anchor.topLeft;
    add(cam!);
    add(currentLevel!);
  }
}
