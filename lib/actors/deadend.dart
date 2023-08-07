import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// class has components of deadend of the map
class DeadEnd extends PositionComponent with CollisionCallbacks {
  // constructor
  DeadEnd({required size, required position})
      : super(size: size, position: position) {}

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
