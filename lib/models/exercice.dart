import 'package:trackout_f/models/repetition.dart';

class Exercice{
  String exerciceId;
  String workoutId;
  String name;
  String description;
  String image;
  List<Repetition> reps;

  Exercice(
      this.exerciceId,
      this.workoutId,
      this.name,
      this.description,
      this.image,
      this.reps
      );

  factory Exercice.fromJson(dynamic json){
    Iterable iterable = json['reps'];
    List<Repetition> reps = List<Repetition>.from(iterable.map((e) => Repetition.fromJson(e)));


    return Exercice(
      json['exerciceId'],
      json['workoutId'],
      json['name'],
      json['description'],
      json['image'],
      reps
    );
  }
}