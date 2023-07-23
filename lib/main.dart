import 'package:flutter/material.dart';

import 'home/home_state.dart';

void main() {
  runApp(App());
  return;
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
