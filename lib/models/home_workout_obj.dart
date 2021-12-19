import 'package:trackout_f/models/responses/workout_response.dart';

class HomeWorkoutObj {
  bool isLoading = true;
  WorkoutResponse? workoutResponse;

  HomeWorkoutObj(this.isLoading, this.workoutResponse);
}
