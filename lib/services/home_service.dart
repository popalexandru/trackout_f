import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:trackout_f/models/home_workout_obj.dart';
import 'package:trackout_f/models/responses/workout_response.dart';

enum ApiAction { fetch }

class HomeService{

  /* pipe for data */
  final _workoutStreamController = StreamController<HomeWorkoutObj>();
  /*final _loadingStreamController = StreamController<bool>();*/

  /* pipe for events */
  final _eventStreamController = StreamController<DateTime>();

  /* sink for data in */
  StreamSink<HomeWorkoutObj> get _workoutSink =>
      _workoutStreamController.sink;
 /* StreamSink<bool> get _loadingSink =>
      _loadingStreamController.sink;*/

  /* stream for data out */
  /* listen into view */
  Stream<HomeWorkoutObj> get workoutStream =>
      _workoutStreamController.stream;
/*  Stream<bool> get loadingStream =>
      _loadingStreamController.stream;*/

  /* sink for receiving data from UI */
  StreamSink<DateTime> get eventStreamSink => _eventStreamController.sink;

  /* stream for listening to events */
  Stream<DateTime> get _eventStream => _eventStreamController.stream;

  HomeService(){
    _eventStream.listen((event) async {
        _startLoading();

        
        try{
          var workoutResponse = await _getWorkoutByDate(_getDateString(event));
          _workoutSink.add(HomeWorkoutObj(false, workoutResponse));

          /*_stopLoading();*/

        } on Exception catch (e){
          _workoutSink.addError("Something went wrong");
        }

    });
  }
  
  Future<WorkoutResponse> _getWorkoutByDate(String dateString) async {
    print("Getting workouts for $dateString");

    Uri url = Uri.parse('https://thawing-eyrie-58399.herokuapp.com/api/workout/get?dateParam=$dateString');
    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    });

    print(response.body);


    return WorkoutResponse.fromJson(json.decode(response.body));
  }

  String _getDateString(DateTime date){
    return DateFormat("dd/MM/yyyy").format(date);
  }

  void _startLoading(){
    _workoutSink.add(HomeWorkoutObj(true, null));
  }

  /*
  void _stopLoading(){
    _loadingSink.add(false);
  }*/
}