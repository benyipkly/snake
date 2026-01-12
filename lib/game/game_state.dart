import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/retro_theme.dart';

enum Direction { up, down, left, right }

enum GameStatus { menu, playing, gameOver }

class SnakeGame extends ChangeNotifier {
  List<Point<int>> snake = [];
  Point<int>? food;
  Direction _direction = Direction.right;
  GameStatus status = GameStatus.menu;
  int score = 0;
  Timer? _ticker;
  final Random _random = Random();

  Direction get direction => _direction;

  SnakeGame() {
    _reset();
  }

  void startGame() {
    _reset();
    status = GameStatus.playing;
    notifyListeners();
    _startTicker();
  }

  void _reset() {
    snake = [const Point(10, 15), const Point(9, 15), const Point(8, 15)];
    _direction = Direction.right;
    score = 0;
    _inputQueue.clear();
    _spawnFood();
  }

  void _spawnFood() {
    // Try to find a spot not occupied by the snake
    while (true) {
      int x = _random.nextInt(RetroTheme.columns);
      int y = _random.nextInt(RetroTheme.rows);
      Point<int> p = Point(x, y);
      if (!snake.contains(p)) {
        food = p;
        break;
      }
    }
  }

  final List<Direction> _inputQueue = [];

  void changeDirection(Direction newDirection) {
    if (status != GameStatus.playing) return;

    // Determine the "last known direction" that the snake WILL be facing
    // after it finishes processing the current queue.
    // If the queue is empty, it's the current direction (or the next committed one).
    // Actually, simpler: verify against the *last queued* direction or current _direction.

    Direction lastDirection = _inputQueue.isNotEmpty
        ? _inputQueue.last
        : _direction;

    // Prevent adding too many inputs (buffer limit)
    if (_inputQueue.length >= 2) return;

    // Check validity against the last planned move
    bool isValid = false;
    if (newDirection == Direction.up &&
        lastDirection != Direction.down &&
        lastDirection != Direction.up)
      isValid = true;
    if (newDirection == Direction.down &&
        lastDirection != Direction.up &&
        lastDirection != Direction.down)
      isValid = true;
    if (newDirection == Direction.left &&
        lastDirection != Direction.right &&
        lastDirection != Direction.left)
      isValid = true;
    if (newDirection == Direction.right &&
        lastDirection != Direction.left &&
        lastDirection != Direction.right)
      isValid = true;

    if (isValid) {
      _inputQueue.add(newDirection);
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _tick();
    });
  }

  void _tick() {
    if (status != GameStatus.playing) return;

    // Process the next input in the queue
    if (_inputQueue.isNotEmpty) {
      _direction = _inputQueue.removeAt(0);
    }

    Point<int> head = snake.first;
    Point<int> newHead;

    // ... rest of movement logic ...

    switch (_direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Check collisions
    if (_checkCollision(newHead)) {
      _gameOver();
      return;
    }

    snake.insert(0, newHead);

    // Check food
    if (newHead == food) {
      score += 10;
      _spawnFood();
      // Increase speed slightly? For now constant speed.
    } else {
      snake.removeLast();
    }

    notifyListeners();
  }

  bool _checkCollision(Point<int> p) {
    // Wall collision
    if (p.x < 0 ||
        p.x >= RetroTheme.columns ||
        p.y < 0 ||
        p.y >= RetroTheme.rows) {
      return true;
    }
    // Self collision
    if (snake.contains(p)) {
      return true;
    }
    return false;
  }

  void _gameOver() {
    status = GameStatus.gameOver;
    _ticker?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
