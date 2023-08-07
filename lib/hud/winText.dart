import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

// this class contains hud of the game
class WinText extends Component {
  @override
  FutureOr<void> onLoad() {
    // displaying the score
    final gamewinText = TextComponent(
        text: 'Congratulations!',
        position: Vector2(772, 240),
        anchor: Anchor.center,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 40,
                fontFamily: 'TmonMonsori')));
    add(gamewinText);
    final winText = TextComponent(
        text: 'You Win!',
        position: Vector2(772, 350),
        anchor: Anchor.center,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 40,
                fontFamily: 'TmonMonsori')));
    add(winText);
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
