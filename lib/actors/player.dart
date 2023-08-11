import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:pixel_adventure/actors/deadend.dart';
import 'package:pixel_adventure/actors/traps/radish.dart';
import 'package:pixel_adventure/actors/traps/rockhead.dart';
import 'package:pixel_adventure/actors/ground.dart';
import 'package:pixel_adventure/actors/traps/saw.dart';
import 'package:pixel_adventure/actors/utils/audiomanager.dart';
import 'package:pixel_adventure/actors/utils/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running, jumping, falling, doubleJump }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  Vector2 spawn;
  Player({position, required this.character, required this.spawn})
      : super(position: position);

  // declaring local variables
  bool jumped = false;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  double moveSpeed = 100;
  double stepTime = 0.05;
  double gravity = 9.8;
  double jump = 180;
  double jumpDouble = 160;
  Vector2 velocity = Vector2.zero();
  int moveX = 0;
  bool facingRight = true;
  Vector2 up = Vector2(0, -1);
  bool onGround = false;
  double upperLim = 250;
  List<Ground> blocks = [];
  double hitboxX = 10;
  double hitboxY = 4;
  double hitboxWidth = 14;
  double hitboxHeight = 28;
  bool canDoubleJump = false;
  bool doubleJumped = false;
  // display
  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimation();
    await super.onLoad();
    add(RectangleHitbox(
        position: Vector2(hitboxX, hitboxY),
        size: Vector2(hitboxWidth, hitboxHeight)));
  }

  // collision events
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Rockhead ||
        other is Saw ||
        other is Radish ||
        other is DeadEnd) {
      //AudioManager.playSound('hit.wav', 0.3);
      gameRef.playerStats.lives.value -= 1;
      position = Vector2(10000,
          10000); // travel to a random location where the character is not visible
      // the player has no lives left
      if (gameRef.playerStats.lives.value < 1) {
        Future.delayed(const Duration(milliseconds: 500), () {
          gameRef.loadLevel('GameOver.tmx'); // gameover page
          AudioManager.stopBgm();
        });
      } else {
        AudioManager.playSfx('hit.wav', 0.4);
        Future.delayed(const Duration(seconds: 2), () {
          respawn(); // respawn effect
        });
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  // key controls
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final leftKeyPressed = (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft));
    final rightKeyPressed = (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight));
    jumped = (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp));

    if (leftKeyPressed && rightKeyPressed) {
      moveX = 0;
    } else if (leftKeyPressed) {
      moveX = -1;
    } else if (rightKeyPressed) {
      moveX = 1;
    } else {
      moveX = 0;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  // updating player movement
  @override
  void update(double dt) {
    updatePlayerState();
    updateMovement(dt);
    checkHorizontalCollisions();
    applyGravity(dt);
    checkVerticalCollisions();
    super.update(dt);
  }

  void updatePlayerState() {
    current = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) {
      current = PlayerState.running;
    }
    if (velocity.y < 0) {
      current = PlayerState.jumping;
    }

    if (velocity.y > 0) {
      current = PlayerState.falling;
    }
    if (doubleJumped && velocity.y < 0) {
      current = PlayerState.doubleJump;
    }
  }

  // movement control
  void updateMovement(double dt) {
    // jumped and the player is on the ground
    if (jumped && onGround) {
      velocity.y = -jump;
      position.y += velocity.y * dt;
      onGround = false;
      jumped = false;
      canDoubleJump = true;
    }

    // double jump is possible and jumped
    if (canDoubleJump && jumped) {
      AudioManager.playSfx('jump.wav', 1);
      velocity.y = -jumpDouble;
      position.y += velocity.y * dt;
      canDoubleJump = false;
      doubleJumped = true;
    }
    if (velocity.y > gravity) {
      onGround = false;
    }
    velocity.x = moveX * moveSpeed;
    position.x += velocity.x * dt;
  }

  // apply gravity all the time
  void applyGravity(double dt) {
    velocity.y += gravity;
    velocity.y = velocity.y.clamp(-jump, upperLim);
    position.y += velocity.y * dt;
  }

  // horizontal collision
  void checkHorizontalCollisions() {
    for (final block in blocks) {
      if (!block.jumpPlatform) {
        if (checkCollision(this, block)) {
          // moving forward
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x =
                block.x - hitboxX - hitboxWidth; // caluculates with hitbox

            break;
          }
          // moving backward
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitboxWidth + hitboxX;

            break;
          }
        }
      }
    }
  }

// vertical collision for platforms
  void checkVerticalCollisions() {
    for (final block in blocks) {
      if (block.jumpPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitboxHeight - hitboxY;
            onGround = true;
            canDoubleJump = false;
            doubleJumped = false;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitboxHeight - hitboxY;
            onGround = true;
            canDoubleJump = false;
            doubleJumped = false;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitboxY;
          }
        }
      }
    }
  }

  // loading all animations
  void _loadAllAnimation() {
    idleAnimation = spriteAnimation('Idle', 11);
    runningAnimation = spriteAnimation('Run', 12);
    jumpingAnimation = spriteAnimation('Jump', 1);
    fallingAnimation = spriteAnimation('Fall', 1);
    doubleJumpAnimation = spriteAnimation('Double Jump', 6);

    // update enum
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.doubleJump: doubleJumpAnimation
    };
  }

  // fetching images and creating animations
  SpriteAnimation spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void respawn() {
    add(
      OpacityEffect.fadeOut(
        EffectController(alternate: true, duration: 0.1, repeatCount: 5),
      ),
    );
    position = Vector2(spawn.x, spawn.y); // respawn
  }
}
