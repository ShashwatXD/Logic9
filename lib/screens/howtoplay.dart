import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A789),
        title: const Text(
          'How to Play',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white, 
          ),
        ),
        elevation: 5, 
      ),
      body: Container(
        color: const Color(0xFFD0E6A5),
        padding: const EdgeInsets.all(20.0), 
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              const Text(
                "1. Select a Level",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Text(
                " Tap the Play button on the home screen and choose your desired level.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              const Text(
                "2. Fill the Grid",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Text(
                " Place numbers (1-9) in the empty spaces of the 9x9 Sudoku grid. "
                "You cannot change the pre-filled numbers.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              const Text(
                "3. Follow the Rules",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Text(
                "   Each row must contain numbers 1-9 without repetition.\n"
                "   Each column must also have unique numbers from 1-9.\n"
                "   Each 3x3 box must contain 1-9 without duplicates.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              const Text(
                "4. Check Your Solution",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Text(
                " If the grid is correctly filled, you complete the level.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              const Text(
                "5. Move to the Next Level",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Text(
                " Solve more puzzles and improve your Sudoku skills.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 100),
              Center(
                child:
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF86A789),
                ),
                child: const Text(
                  "Got It!",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ),
              SizedBox(height: 1000,)
               ]
            ,
          ),
        ),
      ),
    );
  }
}