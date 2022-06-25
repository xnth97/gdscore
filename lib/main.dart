import 'package:flutter/material.dart';
import 'package:gdscore/model/game.dart';
import 'package:provider/provider.dart';
import 'view/scoreboard_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gdscore',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.blue,
        errorColor: Colors.red,
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => GameModel(),
        child: const ScoreboardPage(),
      ),
    );
  }
}
