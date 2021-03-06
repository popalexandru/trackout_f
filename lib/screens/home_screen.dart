import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:horizontal_calendar/horizontal_calendar.dart';
import 'package:trackout_f/components/exercice_card_view.dart';
import 'package:trackout_f/models/example.dart';
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

final homeService = HomeService();

class _HomeState extends State<Home> {
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
            //Navigator.pushNamed(context, '/examples');
            _navigateAndDisplayItemAdded(context);
          },
          label: Row(
            children: [
              Icon(Icons.add) /*, Text('Add exercice')*/
            ],
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
                    WorkoutResponse workoutResponse =
                        snapshot.data!.workoutResponse!;
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 23,
                                                    )),
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  workout.exerciceList!.length,
                                              itemBuilder: (context, index) {
                                                Exercice exercice = workout
                                                    .exerciceList![index];
                                                return Dismissible(
                                                    key: UniqueKey(),
                                                    background: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                      )),
                                                    ),
                                                    onDismissed: (direction) {
                                                      homeService
                                                          .deleteExercice(
                                                              exercice
                                                                  .exerciceId);
                                                    },
                                                    child:
                                                        ExerciceCard(exercice));
                                              },
                                            ),
                                            TextButton.icon(
                                              onPressed: () {},
                                              icon: Icon(Icons.web),
                                              label: Text(
                                                'Start Workout',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: Colors.lightBlue,
                                                onSurface: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : NoExercices()),
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
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: LiquidCircularProgressIndicator(
                                      value: workout.waterQty / 2500,
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.lightBlueAccent),
                                      backgroundColor: Colors.white,
                                      borderColor: Colors.lightBlueAccent,
                                      borderWidth: 3.0,
                                      direction: Axis.vertical,
                                      center:
                                          Text("${workout.waterQty} / 2500 ml"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Card(
                                              child: TextButton(
                                                  onPressed: () {
                                                    homeService.addWater(300);
                                                  },
                                                  child: Text('300 ml')),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Card(
                                              child: TextButton(
                                                  onPressed: () {
                                                    homeService.addWater(600);
                                                  },
                                                  child: Text('600 ml')),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Card(
                                                child: TextButton(
                                                    onPressed: () {
                                                      homeService.addWater(900);
                                                    },
                                                    child: Text('900 ml')))),
                                      ],
                                    ),
                                  )
                                ],
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
            StreamBuilder<String>(
                stream: homeService.errorStream.asBroadcastStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance!
                        .addPostFrameCallback((_) => _showMyDialog(context));
                  }
                  return const SizedBox(
                    height: 1,
                    width: 1,
                  );
                })
          ],
        )
    );
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

void _navigateAndDisplayItemAdded(BuildContext context) async {
  final result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ExampleScreen()))
      as Example;

/*  ScaffoldMessenger.of(context)
  ..removeCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text('Added ${result.description}')));*/

  homeService.eventAddSink.add(result);
}

Future<void> _showMyDialog(BuildContext context) async {
/*  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                  height: 100,
                  child: Image.network('https://cdn-icons.flaticon.com/png/512/4094/premium/4094482.png?token=exp=1640036961~hmac=c02457309bc4db65e1cd63a805894d60')),
              Text('Error deleting item',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.bold
              ),),
            ],
          )
      );
    },
  );*/
  final snackBar = SnackBar(content: Text('Error deleting the exercice'));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
