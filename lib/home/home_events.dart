import 'package:flutter/material.dart';

abstract class HomeEvent {}

class OnPointerMove extends HomeEvent {
  final PointerMoveEvent details;
  OnPointerMove(this.details);
}

class OnPointerDown extends HomeEvent {}

class OnPointerUp extends HomeEvent {}

class OnRedButtonTap extends HomeEvent {}

class OnPurpleButtonTap extends HomeEvent {}

class OnBlueButtonTap extends HomeEvent {}
