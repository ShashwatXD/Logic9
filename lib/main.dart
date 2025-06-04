import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sudofutter/engine/problems_load.dart';
import 'package:sudofutter/screens/gamescreen.dart';
import 'package:sudofutter/screens/homepage.dart';
import 'package:sudofutter/screens/like.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await SudokuProblemManager.init(); 

  runApp(MyApp());

}





class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/background.jpg'), context);

    precacheImage(const AssetImage('assets/images/gameback.jpg'), context);
    precacheImage(const AssetImage('assets/images/htp.png'), context);

    Future.microtask(() {
      HomeScreen();
      

    
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      
      onGenerateRoute: (settings) {
        if (settings.name == '/game') {
          final args = settings.arguments as Map<String, dynamic>;
          final level = args['level'] as int;
          final puzzle = args['puzzle'] as List<List<int>>;

          return MaterialPageRoute(
            builder: (context) => GameScreen(
              puzzle: puzzle,
              level: level,
            ),
          );
        }
        return null;
      },
    );
  }
}
