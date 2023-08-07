import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/actors/utils/audiomanager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

// enum containing different animations of fruits
enum Fruits { apple, banana, orange, pineapple, kiwi }

// this class contains components of fruit animation
class Fruit extends SpriteAnimationGroupComponent
    with CollisionCallbacks, HasGameRef<PixelAdventure> {
  // local variables
  double stepTime = 0.05;
  // constructor
  Fruit({size, required position}) : super(size: size, position: position) {}
  late final SpriteAnimation apple;
  late final SpriteAnimation banana;
  late final SpriteAnimation orange;
  late final SpriteAnimation pineapple;
  late final SpriteAnimation kiwi;

  set z(int z) {}

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    add(CircleHitbox(
        radius: 8, position: Vector2(7, 6))); //circular hitbox for fruit

    await super.onLoad();
  }

  // if player collides with fruit
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      AudioManager.playSfx('grab_item.wav', 1);
      add(RemoveEffect()); // remove from map
      gameRef.playerStats.score.value += 1; // score increment
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  // loading all animations of fruit
  void _loadAllAnimation() {
    // getting animations
    apple = _fruitDisplay('Apple', 17);
    banana = _fruitDisplay('Bananas', 17);
    orange = _fruitDisplay('Orange', 17);
    pineapple = _fruitDisplay('Pineapple', 17);
    kiwi = _fruitDisplay('Kiwi', 17);
    // level 1 = apple
    if (game.playerStats.level.value == 1) current = Fruits.apple;
    // level 2 = pineapple
    if (game.playerStats.level.value == 2) current = Fruits.pineapple;
    // level 3 = orange
    if (game.playerStats.level.value == 3) current = Fruits.orange;
    // level 4 = strawberry
    if (game.playerStats.level.value == 4) current = Fruits.kiwi;
    // updating enum fruits
    animations = {
      Fruits.apple: apple,
      Fruits.banana: banana,
      Fruits.orange: orange,
      Fruits.pineapple: pineapple,
      Fruits.kiwi: kiwi
    };
  }

  // fetching image from cache and getting animation
  SpriteAnimation _fruitDisplay(String fruit, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/$fruit.png'),
        // amount = # of pictures, stepTime = frame
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }
}
