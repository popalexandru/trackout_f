import '../workout.dart';

class WorkoutResponse{
  Workout? workout;
  String message = '';

  WorkoutResponse(
      this.workout,
      this.message
      );

  factory WorkoutResponse.fromJson(dynamic json){
    if(json['workout'] == null){
      return WorkoutResponse(null, "Workout doesnt exist");
    }
    return WorkoutResponse(
        Workout.fromJson(
            json['workout']),
            json['message']
    );
  }
}