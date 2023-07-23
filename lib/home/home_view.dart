import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:ui' as ui;

import 'home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Listener(
        onPointerMove: (details) {
          state.onEvent(OnPointerMove(details));
        },
        child: Stack(
          children: [
            CustomPaint(
              size: size,
              painter: SmoothLinePainter(
                offsets: state.offsets,
                // offsets: [
                //   Offset(100, 100),
                //   Offset(300, 100),
                //   Offset(200, 200),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmoothLinePainter extends CustomPainter {
  final List<Offset> offsets;
  final bool debugPoints;

  SmoothLinePainter({
    required this.offsets,
    this.debugPoints = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (offsets.length < 2) {
      return;
    }
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(offsets.first.dx, offsets.first.dy);

    for (int i = 0; i < offsets.length - 1; i++) {
      final offset = offsets[i];
      final nextOffset = offsets[i + 1];

      final averageOfCurrentAndNext = _getMidPoint(offset, nextOffset);

      // current offset is the control point
      // draw to the mid point between current and next
      path.quadraticBezierTo(
        offset.dx,
        offset.dy,
        averageOfCurrentAndNext.dx,
        averageOfCurrentAndNext.dy,
      );
    }
    path.lineTo(offsets.last.dx, offsets.last.dy);

    canvas.drawPath(path, paint);
    if (debugPoints) {
      Paint pointPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.white;
      canvas.drawPoints(ui.PointMode.points, offsets, pointPaint);
    }
    return;
  }

  Offset _getMidPoint(Offset offset1, Offset offset2) {
    double midDx = (offset1.dx + offset2.dx) / 2;
    double midDy = (offset1.dy + offset2.dy) / 2;
    return Offset(midDx, midDy);
  }

  @override
  bool shouldRepaint(SmoothLinePainter oldDelegate) {
    return true;
  }
}
