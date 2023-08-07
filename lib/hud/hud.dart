import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// this class contains hud of the game
class Hud extends Component with HasGameRef<PixelAdventure> {
  @override
  FutureOr<void> onLoad() {
    // displaying the score
    final scoreText = TextComponent(
        text: 'Score: ${gameRef.playerStats.score.value}',
        position: Vector2(120, 20),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 40,
                fontFamily: 'TmonMonsori')));
    add(scoreText);
    // updating the score as the game continues
    gameRef.playerStats.score.addListener(() {
      scoreText.text = 'Score: ${gameRef.playerStats.score.value}';
    });

    final livesText = TextComponent(
        text: 'x ${gameRef.playerStats.lives.value}',
        position: Vector2(1315, 30),
        anchor: Anchor.topRight,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 30,
                fontFamily: 'TmonMonsori')));
    add(livesText);
    gameRef.playerStats.lives.addListener(() {
      livesText.text = 'x ${gameRef.playerStats.lives.value}';
    });
    return super.onLoad();
  }
}
