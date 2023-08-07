import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';

// this class contains hud of the game
class SelectCharacterText extends Component {
  @override
  FutureOr<void> onLoad() {
    // displaying the score
    final pixelAdventureText = TextComponent(
        text: 'Pixel Adventure',
        position: Vector2(800, 350),
        anchor: Anchor.center,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 45,
                fontFamily: 'TmonMonsori')));
    add(pixelAdventureText);
    final characterChooseText = TextComponent(
        text: 'Choose your character!',
        position: Vector2(950, 430),
        anchor: Anchor.bottomRight,
        textRenderer: TextPaint(
            style: TextStyle(
                color: BasicPalette.white.color,
                fontSize: 25,
                fontFamily: 'TmonMonsori')));
    add(characterChooseText);
    return super.onLoad();
  }
}
