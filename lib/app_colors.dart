import 'package:flutter/material.dart';

class AppColors {
  static const Color pastelBlue = Color(0xFFA7C7E7);
  static const Color pastelGreen = Color(0xFF77DD77);
  static const Color pastelPink = Color(0xFFFFB6C1);
  static const Color pastelPurple = Color(0xFFB39EB5);
  static const Color pastelYellow = Color(0xFFFDFD96);
  static const Color lightGrey = Color(0xFFF0F0F0);

  // Gradient Colors
  static const List<Color> gradientButton = [pastelYellow, pastelGreen];
  static const List<Color> gradientButtonSec = [AppColors.pastelYellow, AppColors.pastelPink];
  static const Color gradientEnd = pastelPurple;
  static Color textIndigo = Colors.indigo.shade900;
  static Color backgroundGreen = Colors.green.shade50;

  static Color pastelGreenLight = pastelGreen.withOpacity(0.7);
  static Color pastelYellowLight = pastelYellow.withOpacity(0.7);
  static Color pastelPinkLight = pastelPink.withOpacity(0.7);
  static Color pastelPurpleLight = pastelPurple.withOpacity(0.7);

  static Color pastelGreenDark = Color.lerp(pastelGreen, Colors.black, 0.2)!;
  static Color pastelYellowDark = Color.lerp(pastelYellow, Colors.black, 0.2)!;
  static Color pastelPinkDark = Color.lerp(pastelPink, Colors.black, 0.2)!;
  static Color pastelPurpleDark = Color.lerp(pastelPurple, Colors.black, 0.2)!;

}