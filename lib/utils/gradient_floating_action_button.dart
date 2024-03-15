import 'package:flutter/material.dart';

import '../app_colors.dart';

class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;

  const GradientFloatingActionButton({super.key, required this.onPressed, required this.icon, this.tooltip = ''});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientButton,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          tooltip: tooltip,
          child: Icon(icon),
        ),
      ),
    );
  }
}

