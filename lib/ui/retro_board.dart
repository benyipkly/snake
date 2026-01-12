import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/retro_theme.dart';

class RetroBoard extends StatelessWidget {
  final List<Point<int>> snake;
  final Point<int>? food;

  const RetroBoard({super.key, required this.snake, required this.food});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: RetroTheme.columns / RetroTheme.rows,
      child: Container(
        decoration: BoxDecoration(
          color: RetroTheme.nokiaBackground,
          border: Border.all(color: RetroTheme.darkPixel, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: CustomPaint(
          painter: BoardPainter(snake: snake, food: food),
        ),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int>? food;

  BoardPainter({required this.snake, required this.food});

  @override
  void paint(Canvas canvas, Size size) {
    final double pixelWidth = size.width / RetroTheme.columns;
    final double pixelHeight = size.height / RetroTheme.rows;

    final Paint pixelPaint = Paint()
      ..color = RetroTheme.nokiaPixel
      ..style = PaintingStyle.fill;

    // Draw Snake
    for (var point in snake) {
      // Add a small gap for the "grid" look
      final rect = Rect.fromLTWH(
        point.x * pixelWidth + 1,
        point.y * pixelHeight + 1,
        pixelWidth - 2,
        pixelHeight - 2,
      );
      canvas.drawRect(rect, pixelPaint);
    }

    // Draw Food
    if (food != null) {
      final rect = Rect.fromLTWH(
        food!.x * pixelWidth + 1,
        food!.y * pixelHeight + 1,
        pixelWidth - 2,
        pixelHeight - 2,
      );
      // Maybe make food a circle or a different shape? classic is just a block
      // Let's make it a block but maybe stroke? No, solid block is classic.
      canvas.drawRect(rect, pixelPaint);
    }

    // Optional: Draw faint grid lines?
    // Nah, classic nokia didn't really show grid lines usually, just the pixels.
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return true; // Always repaint as the list is mutated in place
  }
}
