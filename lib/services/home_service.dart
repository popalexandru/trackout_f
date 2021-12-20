import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:trackout_f/models/example.dart';
import 'package:trackout_f/models/home_workout_obj.dart';
import 'package:trackout_f/models/responses/workout_response.dart';

enum ApiAction { fetch }

class HomeService{

  /* pipe for data */
  final _workoutStreamController = StreamController<HomeWorkoutObj>();
  final _eventOnAddController = StreamController<Example>();

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
  StreamSink<Example> get eventAddSink => _eventOnAddController.sink;

  /* stream for listening to events */
  Stream<DateTime> get _eventStream => _eventStreamController.stream;
  Stream<Example> get _eventAddStream => _eventOnAddController.stream;

  late DateTime lastDateTimeFetched;
  late WorkoutResponse lastWorkoutFetched;

  HomeService(){
    _eventAddStream.listen((event) async {
      print('Adding ${event.name}');

      var exerciceAdded = await _addExercice(event.id, lastWorkoutFetched.workout!.workoutId);

      if(exerciceAdded){
        eventStreamSink.add(lastDateTimeFetched);
      }
    });

    _eventStream.listen((event) async {
        _startLoading();

        try{
          var workoutResponse = await _getWorkoutByDate(_getDateString(event));
          _workoutSink.add(HomeWorkoutObj(false, workoutResponse));

          lastDateTimeFetched = event;
          lastWorkoutFetched = workoutResponse;
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

  Future<bool> _addExercice(String exampleId, String workoutId) async {
    Uri url = Uri.parse('https://thawing-eyrie-58399.herokuapp.com/api/exercice/add');

    var headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    var bod = jsonEncode(<String, String>{
      'exampleId': exampleId,
      'workoutId': workoutId
    });

    Response response = await post(url, headers: headers, body: bod);

    return response.statusCode == HttpStatus.ok;
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