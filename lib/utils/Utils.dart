
import 'package:trackout_f/models/workout.dart';

class MyUtils {
  MyUtils(){

  }


  bool isWorkoutOngoing(Workout workout){
    return workout.isWorkoutDone == false
        && workout.timestampStarted > 0
        && workout.timestampDone == -1;
  }

}