import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:trackout_f/screens/examples_screen.dart';
import 'package:trackout_f/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer example',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) { // <--- Important part
        return Stack(
          children: [
            Home(),
            Offstage(
              offstage: false,
              child: Miniplayer(
                minHeight: 70,
                maxHeight: MediaQuery.of(context).size.height*0.75,
                builder: (height, percentage) {
                  if(percentage > 0.2)
                    return Text('maximized');
                  else
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo
                      ),
                      child: Center(
                        child: Text('Ongoing workout', style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
