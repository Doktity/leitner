import 'package:flutter/material.dart';

import '../app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const GradientAppBar({
    super.key,
    required this.title,
    this.onLeadingPressed,
    this.automaticallyImplyLeading = true,
    this.actions
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Mulish",
          fontSize: 24,
          color: AppColors.textIndigo,
        ),
      ),
      leading: onLeadingPressed != null ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onLeadingPressed,
      ) : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientButton,
              begin: Alignment(-0.8, -1),
              end: Alignment(0.8, 1),
            )
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height
}
