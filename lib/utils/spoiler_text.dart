import 'package:flutter/material.dart';

class SpoilerText extends StatefulWidget {
  final String text;
  final double? size;

  const SpoilerText({super.key, required this.text,  this.size});

  @override
  State<SpoilerText> createState() => _SpoilerTextState();
}

class _SpoilerTextState extends State<SpoilerText> {
  bool isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRevealed = !isRevealed;
        });
      },
      child: Text(
        widget.text,
        style: widget.size != null
            ? TextStyle(
              color: isRevealed ? Colors.white : Colors.black,
              backgroundColor: Colors.black,
              fontSize: widget.size
            )
            : TextStyle(
            color: isRevealed ? Colors.white : Colors.black,
            backgroundColor: Colors.black
        ),
      ),
    );
  }
}
