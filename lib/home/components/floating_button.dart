import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Color color;
  final void Function() onTap;
  const FloatingButton({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
      ),
    );
  }
}
