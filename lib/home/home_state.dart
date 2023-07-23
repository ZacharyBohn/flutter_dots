import 'package:flutter/material.dart';
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
  HomeState(super.context);

  List<Offset> offsets = [];
  @override
  void onEvent(HomeEvent event) {
    if (event is OnPointerMove) {
      offsets.add(event.details.localPosition);
      notifyListeners();
    }
    return;
  }
}
