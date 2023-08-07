import 'package:flutter/widgets.dart';

// this class contains stats of the game for pixeladventure class to use
class PlayerStats {
  final score = ValueNotifier<int>(0);
  final level = ValueNotifier<int>(1);
  final lives = ValueNotifier<int>(5);
}
