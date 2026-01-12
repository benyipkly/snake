import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../game/game_state.dart';
import '../theme/retro_theme.dart';
import 'retro_board.dart';
import 'controls.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SnakeGame _game = SnakeGame();

  @override
  void dispose() {
    _game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RetroTheme.primaryColor,
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
              _game.changeDirection(Direction.up),
          const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
              _game.changeDirection(Direction.down),
          const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
              _game.changeDirection(Direction.left),
          const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
              _game.changeDirection(Direction.right),
          const SingleActivator(LogicalKeyboardKey.keyW): () =>
              _game.changeDirection(Direction.up),
          const SingleActivator(LogicalKeyboardKey.keyS): () =>
              _game.changeDirection(Direction.down),
          const SingleActivator(LogicalKeyboardKey.keyA): () =>
              _game.changeDirection(Direction.left),
          const SingleActivator(LogicalKeyboardKey.keyD): () =>
              _game.changeDirection(Direction.right),
        },
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _game.changeDirection(Direction.up);
            } else if (details.primaryVelocity! > 0) {
              _game.changeDirection(Direction.down);
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _game.changeDirection(Direction.left);
            } else if (details.primaryVelocity! > 0) {
              _game.changeDirection(Direction.right);
            }
          },
          child: Focus(
            autofocus: true,
            child: ListenableBuilder(
              listenable: _game,
              builder: (context, child) {
                return Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                        // Removed maxHeight to allow FittedBox to scale the natural height
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 20),
                          _buildScreenArea(),
                          const SizedBox(height: 20),
                          GameControls(
                            onDirectionChanged: _game.changeDirection,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Text(
          'SNAKE',
          style: TextStyle(
            color: RetroTheme.nokiaBackground,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
            // TODO: Add a retro font if possible, for now default bold is okay
            fontFamily: 'Courier',
          ),
        ),
        Text(
          'SCORE: ${_game.score}',
          style: const TextStyle(
            color: RetroTheme.nokiaBackground,
            fontSize: 24,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildScreenArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black, // The physical bezel
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!, width: 5),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              RetroBoard(snake: _game.snake, food: _game.food),
              if (_game.status != GameStatus.playing)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _game.status == GameStatus.gameOver
                                ? "GAME OVER"
                                : "PRESS START",
                            style: const TextStyle(
                              color: RetroTheme.nokiaBackground,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: RetroTheme.nokiaPixel,
                              foregroundColor: RetroTheme.nokiaBackground,
                            ),
                            onPressed: _game.startGame,
                            child: const Text("START"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
