import 'package:flutter/material.dart';

class StyledTooltip extends StatelessWidget {
  final String message;

  const StyledTooltip({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      richMessage: WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Text(message,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Mulish",
              fontSize: 16
            ),
          ),
        )
      ),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: const Icon(Icons.info_outlined),
    );
  }
}
