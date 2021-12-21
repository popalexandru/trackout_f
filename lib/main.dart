import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:trackout_f/screens/examples_screen.dart';
import 'package:trackout_f/screens/home_screen.dart';

import 'components/exercice_card_view.dart';
import 'models/exercice.dart';
import 'models/home_workout_obj.dart';
import 'models/responses/workout_response.dart';
import 'models/workout.dart';

void main() => runApp(MyApp());

final _navigatorKey = GlobalKey<NavigatorState>();
final MiniplayerController controller = MiniplayerController();
ValueNotifier<Workout?> workoutOngoing = ValueNotifier(null);

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFAFAFA),
      ),
      home: SecondHomePage(),
    );
  }
}

class SecondHomePage extends StatelessWidget {
  const SecondHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
        onWillPop: () async {
          final NavigatorState navigator = _navigatorKey.currentState!;
          if (!navigator.canPop()) return true;
          navigator.pop();

          return false;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Navigator(
                key: _navigatorKey,
                onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                  settings: settings,
                  builder: (BuildContext context) => MyHomePage(),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: workoutOngoing,
                builder: (BuildContext context, Workout? workout, Widget? child) =>
                  workout != null ? PlayerSheet(workout) : SizedBox.shrink()
                ,
              )
            ],
          ),
        )
    );
  }
}

class PlayerSheet extends StatelessWidget {
  final Workout workoutOngoingState;

  const PlayerSheet(this.workoutOngoingState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Miniplayer(
      elevation: 4,
      controller: controller,
      minHeight: 70,
      maxHeight: 370,
      builder: (height, percentage) => Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text('Workout ongoing'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(13, 6, 6, 6),
                    child: Text(workoutOngoingState.exerciceList![0].name, style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.play_arrow), onPressed:() {},),
            IconButton(icon: Icon(Icons.close), onPressed:() {
              workoutOngoing.value = null;
            },)
          ],
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: workoutOngoing,
      builder: (BuildContext context, Workout? workout, Widget? child) =>
        Padding(
        padding: workoutOngoing.value == null ? EdgeInsets.all(0) : EdgeInsets.only(bottom: 60.0),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Home screen"),
              centerTitle: false,
              backgroundColor: Colors.indigo,
            ),
            floatingActionButton: FloatingActionButton.extended(
              elevation: 6,
              onPressed: () {
                //Navigator.pushNamed(context, '/examples');
                //_navigateAndDisplayItemAdded(context);
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

/*                    if(workout!.isWorkoutDone){
                          controller.animateToHeight(state: PanelState.DISMISS);
                        }else{
                          controller.animateToHeight(state: PanelState.MIN);
                        }*/


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
                                            onPressed: () {
                                              if(workoutOngoing.value == null){
                                                workoutOngoing.value = workout;
                                                controller.animateToHeight(state: PanelState.MAX);
                                              }
                                            },
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
                        /*WidgetsBinding.instance!
                            .addPostFrameCallback((_) => _showMyDialog(context));*/

                      }
                      return const SizedBox(
                        height: 1,
                        width: 1,
                      );
                    })
              ],
            )
        ),
      ),
    );
  }
}

