import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

// This class is responsible for playing all the sound effects
// and background music in this game.
class AudioManager {
  static final sfx = ValueNotifier(true);
  static final bgm = ValueNotifier(true);

  static Future<void> init() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache
        .loadAll(['bgm.mp3', 'grab_item.wav', 'hit.wav', 'jump.wav']);
  }

  static void playSfx(String file, double volume) {
    if (sfx.value) {
      FlameAudio.play(file, volume: volume);
    }
  }

  static void playBgm(String file) {
    if (bgm.value) {
      FlameAudio.bgm.play(file, volume: 0.07);
    }
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    if (bgm.value) {
      FlameAudio.bgm.resume();
    }
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
