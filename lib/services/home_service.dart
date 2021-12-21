import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:trackout_f/models/example.dart';
import 'package:trackout_f/models/exercice.dart';
import 'package:trackout_f/models/home_workout_obj.dart';
import 'package:trackout_f/models/responses/workout_response.dart';

enum ApiAction { fetch }

class HomeService {
  /* pipe for data */
  final _workoutStreamController = StreamController<HomeWorkoutObj>();
  final _eventOnAddController = StreamController<Example>();
  final _errorEventController = StreamController<String>();

  /* pipe for events */
  final _eventStreamController = StreamController<DateTime>();

  /* sink for data in */
  StreamSink<HomeWorkoutObj> get _workoutSink => _workoutStreamController.sink;

  /* StreamSink<bool> get _loadingSink =>
      _loadingStreamController.sink;*/

  /* stream for data out */
  /* listen into view */
  Stream<HomeWorkoutObj> get workoutStream => _workoutStreamController.stream;

/*  Stream<bool> get loadingStream =>
      _loadingStreamController.stream;*/

  /* sink for receiving data from UI */
  StreamSink<DateTime> get eventStreamSink => _eventStreamController.sink;

  StreamSink<Example> get eventAddSink => _eventOnAddController.sink;
  StreamSink<String> get _errorSink => _errorEventController.sink;

  /* stream for listening to events */
  Stream<DateTime> get _eventStream => _eventStreamController.stream;

  Stream<Example> get _eventAddStream => _eventOnAddController.stream;
  Stream<String> get errorStream => _errorEventController.stream;

  late DateTime lastDateTimeFetched;
  late WorkoutResponse lastWorkoutFetched;

  HomeService() {
    _eventAddStream.listen((event) async {
      print('Adding ${event.name}');
      _startLoading();

      var exerciceAdded =
          await _addExercice(event.id, lastWorkoutFetched.workout!.workoutId);

      if (exerciceAdded) {
        WorkoutResponse updatedWorkout = lastWorkoutFetched;
        updatedWorkout.workout!.exerciceList = await _getExercicesForWorkout();

        _workoutSink.add(HomeWorkoutObj(false, updatedWorkout));
      }
    });

    _eventStream.listen((event) async {
      _startLoading();

      try {
        var workoutResponse = await _getWorkoutByDate(_getDateString(event));
        _workoutSink.add(HomeWorkoutObj(false, workoutResponse));

        lastDateTimeFetched = event;
        lastWorkoutFetched = workoutResponse;
        /*_stopLoading();*/

      } on Exception catch (e) {
        _workoutSink.addError("Something went wrong");
      }
    });
  }

  Future<void> addWater(int waterQty) async {
    print('adding $waterQty water');

    Uri url = Uri.parse('https://thawing-eyrie-58399.herokuapp.com/api/water/add');

    var bod = jsonEncode(<String, String>{
      'waterQty': waterQty.toString(),
      'workoutId': lastWorkoutFetched.workout!.workoutId,
      'date': _getDateString(lastDateTimeFetched)
    });

    var headers = {'Content-Type': 'application/json; charset=UTF-8'};

    Response response = await post(url, headers: headers, body: bod);

    lastWorkoutFetched.workout!.waterQty += waterQty;
    _workoutSink.add(HomeWorkoutObj(false, lastWorkoutFetched));

    print(response.body);
    print(response.statusCode);
  }

  Future<void> deleteExercice(String exerciceId) async {
    print('deleting Exercice');

    var exerciceDeleted = await _deleteExercice(exerciceId);

    if (exerciceDeleted) {
      WorkoutResponse updatedWorkout = lastWorkoutFetched;
      updatedWorkout.workout!.exerciceList = await _getExercicesForWorkout();

      _workoutSink.add(HomeWorkoutObj(false, updatedWorkout));
      print('deleted, refetching');
    }else{
      _workoutSink.add(HomeWorkoutObj(false, lastWorkoutFetched));

      _errorSink.add("Error deleting the item");
    }
  }

  Future<bool> _deleteExercice(String exampleId) async {
    Uri url = Uri.parse(
        'https://thawing-eyrie-58399.herokuapp.com/api/exercice/delete');

    var headers = {'Content-Type': 'application/json; charset=UTF-8'};

    var bod = jsonEncode(<String, String>{
      'exampleId': exampleId,
      'workoutId': lastWorkoutFetched.workout!.workoutId
    });

    Response response = await post(url, headers: headers, body: bod);

    return response.statusCode == HttpStatus.ok;
  }

  Future<WorkoutResponse> _getWorkoutByDate(String dateString) async {
    print("Getting workouts for $dateString");

    Uri url = Uri.parse(
        'https://thawing-eyrie-58399.herokuapp.com/api/workout/get?dateParam=$dateString');
    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    });

    print(response.body);

    return WorkoutResponse.fromJson(json.decode(response.body));
  }

  Future<bool> _addExercice(String exampleId, String workoutId) async {
    Uri url =
        Uri.parse('https://thawing-eyrie-58399.herokuapp.com/api/exercice/add');

    var headers = {'Content-Type': 'application/json; charset=UTF-8'};

    var bod = jsonEncode(
        <String, String>{'exampleId': exampleId, 'workoutId': workoutId});

    Response response = await post(url, headers: headers, body: bod);

    return response.statusCode == HttpStatus.ok;
  }

  Future<List<Exercice>> _getExercicesForWorkout() async {
    Uri url = Uri.parse(
        'https://thawing-eyrie-58399.herokuapp.com/api/workout/exercices?workoutId=${lastWorkoutFetched.workout!.workoutId}');
    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    });

    Iterable iterable = json.decode(response.body);

    return List<Exercice>.from(iterable.map((e) => Exercice.fromJson(e)));
  }

  String _getDateString(DateTime date) {
    return DateFormat("dd/MM/yyyy").format(date);
  }

  void _startLoading() {
    _workoutSink.add(HomeWorkoutObj(true, null));
  }

/*
  void _stopLoading(){
    _loadingSink.add(false);
  }*/
}
