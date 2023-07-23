import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Color color;
  final void Function() onTap;
  final Widget? child;
  const FloatingButton({
    super.key,
    required this.color,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: child,
      ),
    );
  }
}
