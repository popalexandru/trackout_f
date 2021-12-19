import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:trackout_f/components/exercice_card_view.dart';
import 'package:trackout_f/models/exercice.dart';
import 'package:trackout_f/models/home_workout_obj.dart';
import 'package:trackout_f/models/responses/workout_response.dart';
import 'package:trackout_f/models/workout.dart';
import 'package:trackout_f/screens/examples_screen.dart';
import 'package:trackout_f/services/home_service.dart';
import 'package:trackout_f/utils/date_utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homeService = HomeService();
  final dateUtils = DateUtility();

  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    homeService.eventStreamSink.add(DateTime.now());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home screen"),
          centerTitle: false,
          backgroundColor: Colors.indigo,
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 6,
          onPressed: () {
            Navigator.pushNamed(context, '/examples');
          },
          label: Row(
            children: [Icon(Icons.add), Text('Add exercice')],
          ),
        ),
        body: Column(
          children: [
            TableCalendar(
              startDay: DateTime.utc(2010, 10, 16),
              endDay: DateTime.utc(2030, 3, 14),
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.monday,
              initialCalendarFormat: CalendarFormat.week,
              onDaySelected: (day, events, holidays) {
                homeService.eventStreamSink.add(day);
              },
            ),
            Flexible(
              child: StreamBuilder<HomeWorkoutObj>(
                stream: homeService.workoutStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isLoading == false) {
                      WorkoutResponse workoutResponse = snapshot.data!.workoutResponse!;
                      Workout? workout = workoutResponse.workout;
                      return Scaffold(
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (workout!.exerciceList!.length > 0)
                            ? Container(
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Exercices',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23,
                                              )),
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: workout!.exerciceList!.length,
                                        itemBuilder: (context, index) {
                                          Exercice exercice =
                                              workout.exerciceList![index];
                                          return ExerciceCard(exercice);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                    : NoExercices()
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Water',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                      )),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: LiquidCircularProgressIndicator(
                                    value: workout.waterQty/2500,
                                    valueColor: AlwaysStoppedAnimation(
                                        Colors.lightBlueAccent),
                                    backgroundColor: Colors.white,
                                    borderColor: Colors.lightBlueAccent,
                                    borderWidth: 3.0,
                                    direction: Axis.vertical,
                                    center: Text("${workout.waterQty} / 2500 ml"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                  } else {
                    return LoadingWidget();
                  }
                },
              ),
            ),
          ],
        ));
/*    return Scaffold(
        backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("17 Dec"),
        centerTitle: false,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Text('Home')
        ],
      )
    );*/
  }
}

class NoExercices extends StatefulWidget {
  const NoExercices({Key? key}) : super(key: key);

  @override
  _NoExercicesState createState() => _NoExercicesState();
}

class _NoExercicesState extends State<NoExercices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: const [
              Text(
                  'No exercices added',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text('Use the + button to add one')
            ],
          ),
        ),
      ),
    );
  }
}


Path _buildSpeechBubblePath() {
  var path = Path();
  path.addOval(Rect.fromCircle(center: Offset(0, 0), radius: 80.0));

  return path;
}
