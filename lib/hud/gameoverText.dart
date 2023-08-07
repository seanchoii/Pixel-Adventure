import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

// this class contains hud of the game
class GameOverText extends Component {
  @override
  FutureOr<void> onLoad() {
    // displaying the score
    final gameoverText = TextComponent(
        text: 'Game Over!',
        position: Vector2(750, 300),
        anchor: Anchor.center,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 50,
                fontFamily: 'TmonMonsori')));
    add(gameoverText);
    final credit = TextComponent(
        text: 'Made By Sean Choi',
        position: Vector2(1500, 720),
        anchor: Anchor.bottomRight,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 20,
                fontFamily: 'TmonMonsori')));
    add(credit);
    return super.onLoad();
  }
}
