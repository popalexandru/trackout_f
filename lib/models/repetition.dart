class Repetition {
  String workoutId = '';
  String exerciceId = '';
  int reps = 0;
  int weight = 0;

  Repetition(this.workoutId, this.exerciceId, this.reps, this.weight);

  factory Repetition.fromJson(dynamic json) {
    return Repetition(
        json['workoutId'], json['exerciceId'], json['reps'], json['weight']);
  }
}
