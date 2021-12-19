import 'package:flutter/material.dart';
import 'package:trackout_f/screens/examples_screen.dart';
import 'package:trackout_f/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const Home(),
        '/examples': (context) => const ExampleScreen()
        /*'/home': (context) => AppHome()*/
      },
    )
  );
}