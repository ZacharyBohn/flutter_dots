import 'package:flutter/material.dart';
import 'package:flutter_dots/models/free_form.model.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../models/point.model.dart';
import 'components/floating_button.dart';
import 'home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) {
              state.onEvent(OnPointerDown());
            },
            onPointerMove: (details) {
              state.onEvent(OnPointerMove(details));
            },
            child: CustomPaint(
              size: size,
              isComplex: true,
              painter: SmoothLinePainter(
                freeForms: state.freeForms,
                debugPoints: false,
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingButton(
              color: Colors.red,
              onTap: () {
                state.onEvent(OnRedButtonTap());
              },
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10 + 35 + 10,
            child: FloatingButton(
              color: Color.fromRGBO(30, 60, 210, 1.0),
              onTap: () {
                state.onEvent(OnBlueButtonTap());
              },
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: state.stylusColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10 + 35 + 10 + 35 + 10,
            child: FloatingButton(
              color: Colors.purple,
              onTap: () {
                state.onEvent(OnPurpleButtonTap());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SmoothLinePainter extends CustomPainter {
  final List<FreeForm> freeForms;
  final bool debugPoints;

  SmoothLinePainter({
    required this.freeForms,
    this.debugPoints = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // int start = DateTime.now().millisecondsSinceEpoch;
    for (var freeForm in freeForms) {
      final points = freeForm.points;
      if (points.length < 2) {
        return;
      }
      for (int i = 1; i < points.length - 1; i++) {
        _drawBezierPath(
          previous: points[i - 1],
          current: points[i],
          next: points[i + 1],
          canvas: canvas,
        );
      }
      if (points.length < 2) continue;
      final paint = Paint()
        ..color = points.last.color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
      final secondToLast = freeForm.points[freeForm.points.length - 2];
      final last = freeForm.points[freeForm.points.length - 1];
      canvas.drawLine(secondToLast.offset, last.offset, paint);
    }

    if (debugPoints) {
      final offsets = <Offset>[];
      for (var x in freeForms) {
        for (var y in x.points) {
          offsets.add(y.offset);
        }
      }
      Paint pointPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..color = Colors.white;
      canvas.drawPoints(ui.PointMode.points, offsets, pointPaint);
    }

    // int end = DateTime.now().millisecondsSinceEpoch;
    // print('paint done in ${end - start}ms');
    return;
  }

  void _drawBezierPath({
    required PointModel previous,
    required PointModel current,
    required PointModel next,
    required Canvas canvas,
  }) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = ui.Gradient.linear(
        current.offset,
        next.offset,
        [
          current.color,
          next.color,
        ],
      );
    Path path = Path();
    path.moveTo(previous.offset.dx, previous.offset.dy);

    final averageOfCurrentAndNext = _getMidPoint(
      current.offset,
      next.offset,
    );
    final opposite = _getOppositeFrom(
      next.offset,
      current.offset,
    );
    final controlPoint = _getMidPoint(
      opposite,
      averageOfCurrentAndNext,
    );

    // TODO: add in linear gradience
    // current offset is the control point
    // draw to the mid point between current and next
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      current.offset.dx,
      current.offset.dy,
    );
    canvas.drawPath(path, paint);
    return;
  }

  Offset _getMidPoint(Offset offset1, Offset offset2) {
    double midDx = (offset1.dx + offset2.dx) / 2;
    double midDy = (offset1.dy + offset2.dy) / 2;
    return Offset(midDx, midDy);
  }

  Offset _getOppositeFrom(Offset from, Offset target) {
    return -(from - target) + target;
  }

  @override
  bool shouldRepaint(SmoothLinePainter oldDelegate) {
    return true;
  }
}
