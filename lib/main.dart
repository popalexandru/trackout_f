import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:trackout_f/screens/examples_screen.dart';
import 'package:trackout_f/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/': (context) => const Home(),
        '/examples': (context) => const ExampleScreen()
      },
    ),

/*      MaterialApp(
    home: Container(
      child: Column(
        children: [
          Stack(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    SizedBox.expand(child: Home()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Miniplayer(
                        minHeight: 70,
                        maxHeight: 370,
                        builder: (height, percentage) {
                          return Center(
                            child: Text('$height, $percentage'),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  )*/
/*    Miniplayer(
      minHeight: 70,
      maxHeight: 370,
      builder: (height, percentage) {
        return Center(
          child: Text('$height, $percentage'),
        );
      },
    )*/
      );
}
