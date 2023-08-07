import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// name: Sean Choi
// driver class that runs the game pixel adventure
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  PixelAdventure game = PixelAdventure();

  //AudioManager.playBgm('bgm.mp3');
  runApp(GameWidget(game: game));
}
