import 'dart:async';
import 'dart:ui';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/buttons/volume.dart';
import 'package:pixel_adventure/actors/characters/lifecharacter.dart';
import 'package:pixel_adventure/actors/checkpoint.dart';
import 'package:pixel_adventure/actors/deadend.dart';
import 'package:pixel_adventure/actors/characters/maskdude.dart';
import 'package:pixel_adventure/actors/characters/ninjafrog.dart';
import 'package:pixel_adventure/actors/characters/pinkman.dart';
import 'package:pixel_adventure/actors/buttons/restart.dart';
import 'package:pixel_adventure/actors/traps/radish.dart';
import 'package:pixel_adventure/actors/traps/rockhead.dart';
import 'package:pixel_adventure/actors/fruit.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/actors/ground.dart';
import 'package:pixel_adventure/actors/traps/saw.dart';
import 'package:pixel_adventure/actors/traps/spikeball.dart';
import 'package:pixel_adventure/actors/characters/virtualguy.dart';
import 'package:pixel_adventure/actors/win.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

import '../actors/traps/mushroom.dart';

// This class contains components of level
class Level extends World with HasGameRef<PixelAdventure> {
  // local variables
  final String levelName;
  final String playerName;
  // constructor
  Level({required this.levelName, required this.playerName});
  late TiledComponent level;
  List<Ground> blocks = [];
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(levelName,
        Vector2.all(16)); // load tiled map, each tile is 16 x 16 pixels
    await add(level);
    // get objects from the tiled map
    final traps = level.tileMap.getLayer<ObjectGroup>('Traps');
    final spawnPoint = level.tileMap.getLayer<ObjectGroup>('Spawn');
    final ground = level.tileMap.getLayer<ObjectGroup>('Ground');
    final deadend = level.tileMap.getLayer<ObjectGroup>('DeadEnd');
    Player? player;
    if (traps != null) {
      for (final trap in traps.objects) {
        switch (trap.class_) {
          case 'Chain':
            final chain = SpikeBall(
              position: Vector2(trap.x, trap.y),
            );
            add(chain);
            break;
          // class is spikedball
          case 'SpikedBall':
            final spikedBall = SpikeBall(
              position: Vector2(trap.x, trap.y),
              isSpikeBall: true,
            );
            add(spikedBall);
            break;
          // class is enemy
          case 'Rockhead':
            final targetId = int.parse(trap.properties.first.value
                .toString()); // the point where the rockhead travels to
            final target =
                traps.objects.firstWhere((object) => object.id == targetId);
            // add enemy object
            final rockHead = Rockhead(
                position: Vector2(trap.x, trap.y),
                targetPosition: Vector2(target.x, target.y),
                spawn: Vector2(trap.x, trap.y));
            add(rockHead);
            break;
          // class is saw
          case 'Saw':
            final targetId = int.parse(trap.properties.first.value
                .toString()); // the point where saw travels to
            final target =
                traps.objects.firstWhere((object) => object.id == targetId);
            final saw = Saw(
                targetPosition: Vector2(target.x, target.y),
                position: Vector2(trap.x, trap.y),
                spawn: Vector2(trap.x, trap.y));
            add(saw);
            break;
          // class is radish
          case 'Radish':
            final targetId = int.parse(trap.properties.first.value
                .toString()); // the point where the radish travels to
            final target =
                traps.objects.firstWhere((object) => object.id == targetId);
            final radish = Radish(
                targetPosition: Vector2(target.x, target.y),
                position: Vector2(trap.x, trap.y),
                spawn: Vector2(trap.x, trap.y));
            add(radish);
          // class is mushroom
          case 'Mushroom':
            final targetId = int.parse(trap.properties.first.value
                .toString()); // the point where the mushroom travels
            final target =
                traps.objects.firstWhere((object) => object.id == targetId);
            final mush = Mushroom(
                targetPosition: Vector2(target.x, target.y),
                position: Vector2(trap.x, trap.y),
                spawn: Vector2(trap.x, trap.y));
            add(mush);
          default:
        }
      }
    }
    if (spawnPoint != null) {
      // go through spawn object
      for (final spawn in spawnPoint.objects) {
        switch (spawn.class_) {
          // class is player
          case 'Player':
            // add player object
            player = Player(
                character: playerName,
                position: Vector2(spawn.x, spawn.y),
                spawn: Vector2(spawn.x, spawn.y));
            add(player);
            break;

          // class is finish
          case 'Finish':
            // add checkpoint object
            final finish = CheckPoint(
                checkpoint: 'Checkpoint',
                position: Vector2(spawn.x, spawn.y),
                onPlayerEnter: () {
                  gameRef.loadLevel(
                      'Level-0${gameRef.playerStats.level.value}.tmx');
                });
            add(finish);
            break;
          case 'Win':
            // add checkpoint object
            final finish = Win(
                position: Vector2(spawn.x, spawn.y),
                onPlayerEnter: () {
                  gameRef.loadLevel('Win.tmx');
                });
            add(finish);
            break;

          // class is fruit
          case 'Fruit':
            // add fruit object
            final fru = Fruit(position: Vector2(spawn.x, spawn.y));
            add(fru);
            break;
          // class is mask dude
          case 'Mask Dude':
            final maskDude = MaskDude(position: Vector2(spawn.x, spawn.y));
            add(maskDude);
            break;
          // class is ninja frog
          case 'Ninja Frog':
            final ninjaFrog = NinjaFrog(position: Vector2(spawn.x, spawn.y));
            add(ninjaFrog);
            break;
          // class is virtual guy
          case 'Virtual Guy':
            final virtualGuy = VirtualGuy(position: Vector2(spawn.x, spawn.y));
            add(virtualGuy);
            break;
          // class is pink man
          case 'Pink Man':
            final pinkMan = PinkMan(position: Vector2(spawn.x, spawn.y));
            add(pinkMan);
            break;
          // class is restart
          case 'Restart':
            final restart = Restart(position: Vector2(spawn.x, spawn.y));
            add(restart);
            break;
          case 'Volume':
            final volume = Volume(position: Vector2(spawn.x, spawn.y));
            add(volume);
            break;
          case 'LifeCharacter':
            final lCharacter = LifeCharacter(
                position: Vector2(spawn.x, spawn.y),
                character: gameRef.playerName);
            add(lCharacter);
            break;
          // adding text components of the game
          case 'Score':
            final scoreText = TextComponent(
                text: 'Score: ${gameRef.playerStats.score.value}',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.topLeft,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 18,
                        fontFamily: 'TmonMonsori')));
            add(scoreText);
            // updating the score as the game continues
            gameRef.playerStats.score.addListener(() {
              scoreText.text = 'Score: ${gameRef.playerStats.score.value}';
            });
            break;
          case 'Lives':
            final livesText = TextComponent(
                text: 'x ${gameRef.playerStats.lives.value}',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.topRight,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 10,
                        fontFamily: 'TmonMonsori')));
            add(livesText);
            gameRef.playerStats.lives.addListener(() {
              livesText.text = 'x ${gameRef.playerStats.lives.value}';
            });
            break;
          // intro
          case 'PixelAdventure':
            final pixelAdventureText = TextComponent(
                text: 'Pixel Adventure',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.center,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 30,
                        fontFamily: 'TmonMonsori')));
            add(pixelAdventureText);
            break;
          case 'ChooseCharacter':
            final characterChooseText = TextComponent(
                text: 'Choose your character!',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.bottomRight,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 12,
                        fontFamily: 'TmonMonsori')));
            add(characterChooseText);
            break;
          case 'GameOver':
            final gameoverText = TextComponent(
                text: 'Game Over!',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.center,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 20,
                        fontFamily: 'TmonMonsori')));
            add(gameoverText);
            break;
          case 'Credit':
            final credit = TextComponent(
                text: 'Made By Sean Choi',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.bottomRight,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 10,
                        fontFamily: 'TmonMonsori')));
            add(credit);
            break;
          case 'Congratulation':
            final gamewinText = TextComponent(
                text: 'Congratulations!',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.center,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 20,
                        fontFamily: 'TmonMonsori')));
            add(gamewinText);
            break;
          case 'YouWin':
            final winText = TextComponent(
                text: 'You Win!',
                position: Vector2(spawn.x, spawn.y),
                anchor: Anchor.center,
                textRenderer: TextPaint(
                    style: TextStyle(
                        color: BasicPalette.white.color,
                        fontSize: 20,
                        fontFamily: 'TmonMonsori')));
            add(winText);
            break;
          default:
        }
      }
    }
    // without this condition, the program could give out errors if the the map doesnt contain ground object
    if (ground != null) {
      for (final platformLayer in ground.objects) {
        switch (platformLayer.class_) {
          case 'JumpPlatform':
            final jp = Ground(
                size: Vector2(platformLayer.width, platformLayer.height),
                position: Vector2(platformLayer.x, platformLayer.y),
                jumpPlatform: true);
            blocks.add(jp);
            add(jp);
            break;

          default:
            final ground = Ground(
                size: Vector2(platformLayer.width, platformLayer.height),
                position: Vector2(platformLayer.x, platformLayer.y));
            blocks.add(ground);
            add(ground);
            break;
        }
      }
    }
    if (deadend != null) {
      for (final de in deadend.objects) {
        // player loses life if it falls into deadend
        add(DeadEnd(
            size: Vector2(de.width, de.height), position: Vector2(de.x, de.y)));
      }
    }
    if (player != null) {
      player.blocks = blocks;
    }

    return super.onLoad();
  }
}
