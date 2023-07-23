import 'dart:math';

void main() {
  // 0,0 - 1,0 - 2,0
  // 0,1 - 1,1 - 2,1
  // 0,2 - 1,2 - 2,2
  Offset x1 = Offset(0, 0);
  Offset x2 = Offset(2, 1);
  double slope = getSlope(x1, x2);
  double distance = _calculateDistance(x1, x2);
  Offset midPoint = _getMidPoint(x1, x2);
  print(slope);
  print(
      'adjusted midpoint: x: ${midPoint.dx + distance}, y: ${midPoint.dy + (distance * slope)}');

  return;
}

double _calculateDistance(Offset point1, Offset point2) {
  double dx = point2.dx - point1.dx;
  double dy = point2.dy - point1.dy;
  double distance = sqrt(dx * dx + dy * dy);
  return distance;
}

double getSlope(start, end) {
  double denominator = end.dx - start.dx;
  double slope =
      denominator == 0 ? 0 : (end.dy - start.dy) / (end.dx - start.dx);
  return slope;
}

Offset _getMidPoint(Offset offset1, Offset offset2) {
  double midDx = (offset1.dx + offset2.dx) / 2;
  double midDy = (offset1.dy + offset2.dy) / 2;
  return Offset(midDx, midDy);
}

int _comparePointPositions(Offset start, Offset end, Offset thirdPoint) {
  double denominator = end.dx - start.dx;
  double slope =
      denominator == 0 ? 0 : (end.dy - start.dy) / (end.dx - start.dx);
  double yIntercept = start.dy - slope * start.dx;

  double calculatedY = slope * thirdPoint.dx + yIntercept;

  if (thirdPoint.dy > calculatedY) {
    return -1; // Point is below the line
  } else if (thirdPoint.dy < calculatedY) {
    return 1; // Point is above the line
  } else {
    return 0; // Point is on the line
  }
}

class Offset {
  Offset(this.dx, this.dy);
  double dx;
  double dy;
}
