import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trackout_f/components/example_card_view.dart';
import 'package:trackout_f/models/example.dart';
import 'package:trackout_f/services/examples_service.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final exampleService = ExamplesService();

  @override
  void initState() {
    exampleService.eventStreamSink.add(ApiAction.fetch);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add an exercice"),
          centerTitle: false,
          backgroundColor: Colors.indigo,
        ),
        body: StreamBuilder<bool>(
            stream: exampleService.loadingStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return LoadingWidget();
                } else {
                  return DataWidget(exampleService);
                }
              }else{
                return Text('Unexpected Error');
              }
            }));
  }
}

class DataWidget extends StatefulWidget {
  final ExamplesService examplesService;

  const DataWidget(this.examplesService,{Key? key}) : super(key: key);

  @override
  _DataWidgetState createState() => _DataWidgetState(examplesService);
}

class _DataWidgetState extends State<DataWidget> {
  //final exampleService = ExamplesService();
  ExamplesService examplesService;

  _DataWidgetState(this.examplesService);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Example>>(
        stream: examplesService.examplesStream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index){
                  Example ex = snapshot.data![index];

                  return ExampleCard(ex);
                }
            );
          }else{
            return Text('No data');
          }
          //return Text('Unexpected error');
        },
      ),
    );
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
          child: SpinKitFadingCircle(
            color: Colors.black,
          ),
        ));
  }
}
