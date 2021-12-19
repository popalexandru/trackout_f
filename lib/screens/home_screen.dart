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
        body: StreamBuilder<HomeWorkoutObj>(
          stream: homeService.workoutStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isLoading == false) {
                WorkoutResponse workoutResponse = snapshot.data!.workoutResponse!;
                Workout? workout = workoutResponse.workout;

                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            /*decoration: const BoxDecoration(
                                    */ /*color: Color(0xFF828282)*/ /*
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Color(0xff666666),
                                          blurRadius: 5,
                                          spreadRadius: 0.5)
                                    ])*/
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
                          ),
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
                              value: 0.65,
                              valueColor: AlwaysStoppedAnimation(
                                  Colors.lightBlueAccent),
                              backgroundColor: Colors.white,
                              borderColor: Colors.lightBlueAccent,
                              borderWidth: 1.0,
                              direction: Axis.vertical,
                              center: Text("300 ml"),
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

Path _buildSpeechBubblePath() {
  var path = Path();
  path.addOval(Rect.fromCircle(center: Offset(0, 0), radius: 80.0));

  return path;
}
