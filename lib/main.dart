import 'package:flutter/material.dart';
import 'package:sudofutter/screens/gamescreen.dart';
import 'package:sudofutter/screens/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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