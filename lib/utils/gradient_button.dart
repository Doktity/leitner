import 'package:flutter/material.dart';

import '../app_colors.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double widthFactor;
  final double heightFactor;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.widthFactor = 0.8,
    this.heightFactor = 0.1
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.gradientButton, // Gradient colors
          begin: Alignment(-0.8, -1),
          end: Alignment(0.8, 1),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(20)),
            backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
            fixedSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).size.height * 0.1)),
            maximumSize: const MaterialStatePropertyAll(Size(300, 100)),
            foregroundColor: const MaterialStatePropertyAll(Colors.black),
            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
