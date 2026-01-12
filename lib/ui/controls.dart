import 'package:flutter/material.dart';
import '../game/game_state.dart';
import '../theme/retro_theme.dart';

class GameControls extends StatelessWidget {
  final Function(Direction) onDirectionChanged;

  const GameControls({super.key, required this.onDirectionChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(Direction.up, Icons.arrow_drop_up),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Direction.left, Icons.arrow_left),
            const SizedBox(width: 60), // Space for center
            _buildButton(Direction.right, Icons.arrow_right),
          ],
        ),
        _buildButton(Direction.down, Icons.arrow_drop_down),
      ],
    );
  }

  Widget _buildButton(Direction direction, IconData icon) {
    // Retro phone button style
    return GestureDetector(
      onTap: () => onDirectionChanged(direction),
      child: Container(
        width: 80, // Generous touch target
        height: 60,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors
              .transparent, // Invisible touch targets over a potential background image?
          // Or let's style them as actual buttons
          // shape: BoxShape.circle,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[600]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(2, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, size: 40, color: RetroTheme.darkPixel),
        ),
      ),
    );
  }
}
