import 'dart:async';

import 'package:flame/components.dart';

class Ground extends PositionComponent {
  bool jumpPlatform;
  Ground({required size, required position, this.jumpPlatform = false})
      : super(size: size, position: position) {}
  @override
  FutureOr<void> onLoad() {
    return super.onLoad();
  }
}
