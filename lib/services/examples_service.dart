import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:trackout_f/models/example.dart';
import 'package:trackout_f/models/exercice.dart';
import 'package:trackout_f/models/responses/workout_response.dart';

enum ApiAction { fetch }

class ExamplesService{

  /* pipe for data */
  final _examplesStreamController = StreamController<List<Example>>();
  final _loadingStreamController = StreamController<bool>();

  /* pipe for events */
  final _eventStreamController = StreamController<ApiAction>();

  /* sink for data in */
  StreamSink<List<Example>> get _examplesSink =>
      _examplesStreamController.sink;
  StreamSink<bool> get _loadingSink =>
      _loadingStreamController.sink;

  /* stream for data out */
  /* listen into view */
  Stream<List<Example>> get examplesStream =>
      _examplesStreamController.stream;
  Stream<bool> get loadingStream =>
      _loadingStreamController.stream;

  /* sink for receiving data from UI */
  StreamSink<ApiAction> get eventStreamSink => _eventStreamController.sink;

  /* stream for listening to events */
  Stream<ApiAction> get _eventStream => _eventStreamController.stream;

  ExamplesService(){
    _eventStream.listen((event) async {
      if(event == ApiAction.fetch){
        _startLoading();
        
        try{
          var exampleList = await _getExamples();

          _examplesSink.add(exampleList);

          _stopLoading();

        } on Exception catch (e){
          _examplesSink.addError("Something went wrong");

          print(e);
        }
        
        _stopLoading();
      }

    });
  }
  
  Future<List<Example>> _getExamples() async {
    Uri url = Uri.parse('https://thawing-eyrie-58399.herokuapp.com/api/example/get/all');
    Response response = await get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    });

    print(response.body);

    Iterable iterable = json.decode(response.body);

    return List<Example>.from(
      iterable.map((e) => Example.fromJson(e))
    );
  }

  void _startLoading(){
    _loadingSink.add(true);
  }
  
  void _stopLoading(){
    _loadingSink.add(false);
  }
}