import 'dart:async';

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
    return;
  }

  // last item is the current drawing
  final List<FreeForm> _freeForms = [];
  List<FreeForm> get freeForms => _freeForms;

  int _x = 0;

  @override
  void onEvent(HomeEvent event) {
    if (event is OnPointerDown) {
      _freeForms.add(FreeForm());
    }
    if (event is OnPointerMove) {
      _x += 2;
      _x = _x % 400;
      var y = _x;
      if (y > 200) {
        y = 400 - y;
      }
      _freeForms.last.points.add(
        PointModel(
          offset: event.details.localPosition,
          color: Color.fromRGBO(
            0,
            15 + y,
            0,
            1.0,
          ),
        ),
      );
      notifyListeners();
    }
    return;
  }

  @override
  void dispose() {
    super.dispose();
    return;
  }
}
