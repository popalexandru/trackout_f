import 'package:bloc/bloc.dart';

enum ApiEvent{
  fetch,
  startWorkout,
  endWorkout,
  cancelWorkout
}

class HomeBloc extends Bloc<ApiEvent, int>{
  HomeBloc(int initialState) : super(initialState);


}