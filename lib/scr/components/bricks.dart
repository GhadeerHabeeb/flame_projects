import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_projects/scr/rick_breaker.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameRef<BrickBreaker> {
  Brick(Vector2 position, Color color)
      : super(
    position: position,
    size: Vector2(brickWidth, brickHeight),
    anchor: Anchor.center,

    paint: Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill,
    children: [RectangleHitbox()],
  );
  late final SpriteComponent player;

  @override
  Future<void> onLoad() async {
    final orangeAnimation = await gameRef.loadSpriteAnimation(
        'Orange.png',
        SpriteAnimationData.sequenced(
          amount: 15,

          stepTime: 0.1,
          textureSize: Vector2(32, 32),


        ));
    final animation = orangeAnimation;
    final size = Vector2.all(100.0);
    final player = SpriteAnimationComponent(size: size, animation: animation);

    add(
        player); // Adds the component
  }


  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();
   /* FlameAudio.play('collision.wav');*/
    game.score.value++;
    if (game.world.children.query<Brick>().length == 1) {
      game.playState = PlayState.won;                          // Add this line
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
    }
  }
}