// calculates if the player collides with blocks
bool checkCollision(player, block) {
  final playerX = player.position.x + player.hitboxX;
  final playerY = player.position.y + player.hitboxY;
  final playerWidth = player.hitboxWidth;
  final playerHeight = player.hitboxHeight;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0
      ? playerX - (player.hitboxX * 2) - playerWidth
      : playerX;
  final fixedY = block.jumpPlatform ? playerY + playerHeight : playerY;

  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
