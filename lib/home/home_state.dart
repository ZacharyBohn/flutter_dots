import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dots/models/free_form.model.dart';
import 'package:flutter_dots/models/point.model.dart';
import 'package:state_view/state_view.dart';
import 'home_view.dart';
import 'home_events.dart';
export 'home_events.dart';

class Home extends StateView<HomeState> {
  Home({Key? key})
      : super(
          key: key,
          stateBuilder: (context) => HomeState(context),
          view: HomeView(),
        );
}

class HomeState extends StateProvider<Home, HomeEvent> {
  HomeState(super.context) {
    _stylusColor = _stylusColors.first;
    return;
  }

  // last item is the current drawing
  final List<FreeForm> _freeForms = [];
  List<FreeForm> get freeForms => _freeForms;

  int _x = 0;

  late Color _stylusColor;
  Color get stylusColor => _stylusColor;

  final List<Color> _stylusColors = [
    Colors.green,
    Color.fromRGBO(30, 60, 210, 1.0),
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.white,
  ];

  Timer? _longPressTimer;

  final double _deadZone = 3.5;
  Offset? _previousPosition;

  Timer? _consumeTimer;

  @override
  void onEvent(HomeEvent event) {
    if (event is OnPointerDown) {
      if (_freeForms.isEmpty || _freeForms.last.points.isNotEmpty) {
        _freeForms.add(FreeForm());
      }
      _longPressTimer?.cancel();
      _longPressTimer = Timer(
        Duration(milliseconds: 350),
        () {
          _longPressHandler();
        },
      );
    }
    if (event is OnPointerUp) {
      _longPressTimer?.cancel();
    }
    if (event is OnPointerMove) {
      _longPressTimer?.cancel();
      _freeFormHandler(event);
    }
    if (event is OnRedButtonTap) {
      _consumeTimer?.cancel();
      _deleteAllDrawings();
    }
    if (event is OnBlueButtonTap) {
      _cycleStylusColor();
    }
    if (event is OnPurpleButtonTap) {
      if (_consumeTimer?.isActive != true) {
        _startConsume();
      } else {
        _consumeTimer!.cancel();
      }
    }
    return;
  }

  void _startConsume() {
    _consumeTimer = Timer.periodic(
      Duration(milliseconds: 32),
      (_) {
        _moveAllPointsTowardsCenter();
      },
    );
    return;
  }

  void _moveAllPointsTowardsCenter() {
    Size size = MediaQuery.of(context).size;
    Offset center = Offset(size.width / 2, size.height / 2);
    final freeFormsToDelete = <FreeForm>[];
    for (var freeForm in freeForms) {
      for (var point in freeForm.points) {
        point.offset = point.offset.translateTowards(
          targetOffset: center,
          pixels: 1,
        );
      }
      if (freeForm.points.every(
          (element) => element.offset.isWithin(pixels: 1, other: center))) {
        freeFormsToDelete.add(freeForm);
      }
    }
    for (var freeForm in freeFormsToDelete) {
      freeForms.remove(freeForm);
    }
    if (freeForms.isEmpty) {
      _consumeTimer?.cancel();
    }

    notifyListeners();
    return;
  }

  void _longPressHandler() {
    _longPressTimer?.cancel();
    // TODO: implement something here?
    return;
  }

  void _cycleStylusColor() {
    int index = _stylusColors.indexOf(_stylusColor);
    _stylusColor = _stylusColors[(index + 1) % _stylusColors.length];
    notifyListeners();
    return;
  }

  void _freeFormHandler(OnPointerMove event) {
    // TODO: cleanup
    _x += 1;
    _x = _x % 400;
    var y = _x;
    if (y > 200) {
      y = 400 - y;
    }
    if (_previousPosition != null &&
        event.details.localPosition
            .isWithin(pixels: _deadZone, other: _previousPosition!)) {
      return;
    }
    _previousPosition = event.details.localPosition;
    _freeForms.last.points.add(
      PointModel(
        offset: event.details.localPosition,
        color: _stylusColor,
        // color: Color.fromRGBO(
        //   0,
        //   40 + y,
        //   0,
        //   1.0,
        // ),
      ),
    );
    notifyListeners();
    return;
  }

  void _deleteAllDrawings() {
    freeForms.clear();
    notifyListeners();
    return;
  }

  @override
  void dispose() {
    super.dispose();
    return;
  }
}

extension IsWithin on Offset {
  bool isWithin({required double pixels, required Offset other}) {
    double distance = sqrt(
      (dx - other.dx) * (dx - other.dx) + (dy - other.dy) * (dy - other.dy),
    );
    return distance <= pixels;
  }

  Offset translateTowards({
    required Offset targetOffset,
    required double pixels,
  }) {
    double dxDiff = targetOffset.dx - dx;
    double dyDiff = targetOffset.dy - dy;

    double distance = sqrt(dxDiff * dxDiff + dyDiff * dyDiff);
    double scale = pixels / distance;

    double translatedDx = dx + dxDiff * scale;
    double translatedDy = dy + dyDiff * scale;

    return Offset(translatedDx, translatedDy);
  }
}
