import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trackout_f/models/example.dart';
import 'package:trackout_f/models/exercice.dart';

class ExampleCard extends StatelessWidget {
  final Example example;

  const ExampleCard(this.example, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3,
              spreadRadius: 0.1
            )
          ]
        ),/*
        margin: EdgeInsets.symmetric(5),*/
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Text(example.name),
              Text(example.description)
            ],
          ),
        ),
      ),
    );
  }
}
