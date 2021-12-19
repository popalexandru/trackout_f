import 'package:trackout_f/models/exercice.dart';

class Workout{
  String workoutId;
  String userId;
  bool isWorkoutDone;
  String date;
  int timestampDone;
  int waterQty;
  List<Exercice>? exerciceList;

  Workout(
      this.workoutId,
      this.userId,
      this.isWorkoutDone,
      this.date,
      this.timestampDone,
      this.waterQty,
      this.exerciceList
      );

  factory Workout.fromJson(dynamic json){
    Iterable iterable = json['exerciceList'];
    List<Exercice> exercices = List<Exercice>.from(iterable.map((e) => Exercice.fromJson(e)));

    return Workout(
        json['workoutId'],
        json['userId'],
        json['isWorkoutDone'],
        json['date'],
        json['timestampDone'],
        json['waterQty'],
        exercices
    );
  }
}