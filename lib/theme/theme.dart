import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFF1D57F);

  /// Paleta de colores de la aplicacion.
  static const MaterialColor pallete = MaterialColor(0xFF00B4C1, 
    <int, Color>{
        50: Color(0xFFFFFFFF),
        100: Color(0xFFF7F7FA),
        200: Color(0xFFC4C4C4),
        300: Color(0xFFFEECC9),
        400: Color(0xFFF1D57F), //primary
        500: Color(0xFFF1D57F),
        600: Color(0xFFF2C94C),
        700: Color(0xFFFF6536),
        800: Color(0xFFFF4B00), // 35% opacity
        900: Color(0xFF000000)
      });

  AppTheme._();
}
