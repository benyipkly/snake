import 'package:flutter/material.dart';

class RetroTheme {
  static const Color primaryColor = Color(
    0xFF0F380F,
  ); // Dark Green (Game Boy/Nokia LCD background)
  static const Color accentColor = Color(
    0xFF9BBC0F,
  ); // Light Green (Active pixel)
  static const Color darkPixel = Color(
    0xFF0F380F,
  ); // Dark Green (Official Nokia black)
  static const Color lightPixel = Color(
    0xFF8BAC0F,
  ); // Light Green (Official Nokia background)

  // Using a more distinct Nokia 3310 palette
  static const Color nokiaBackground = Color(
    0xFFC7F0D8,
  ); // Light greenish background
  static const Color nokiaPixel = Color(0xFF43523D); // Dark greenish pixel

  static const double pixelSize = 20.0;
  static const int columns = 20;
  static const int rows = 30; // Slightly taller for mobile aspect ratio
}
