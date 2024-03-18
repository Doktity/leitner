import 'package:flutter/material.dart';

import '../app_colors.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double widthFactor;
  final double heightFactor;
  final double maxWidth;
  final double maxHeight;
  final List<Color> colors;
  final double padding;

  const GradientButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.widthFactor = 0.8,
    this.heightFactor = 0.1,
    this.maxWidth = 300,
    this.maxHeight = 100,
    this.colors = AppColors.gradientButton,
    this.padding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors, // Gradient colors
          begin: const Alignment(-0.8, -1),
          end: const Alignment(0.8, 1),
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(padding)),
            backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
            fixedSize: MaterialStatePropertyAll(Size(MediaQuery.of(context).size.width * widthFactor, MediaQuery.of(context).size.height * heightFactor)),
            maximumSize: MaterialStatePropertyAll(Size(maxWidth, maxHeight)),
            foregroundColor: const MaterialStatePropertyAll(Colors.black),
            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  static Widget buildButtonContent(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Mulish",
                fontSize: 24,
                color: AppColors.textIndigo,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
