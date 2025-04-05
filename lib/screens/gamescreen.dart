import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sudofutter/engine/sudoku_engine.dart';

class GameScreen extends StatefulWidget {
  final List<List<int>> puzzle;
  final int level;

  const GameScreen({
    Key? key,
    required this.puzzle,
    required this.level,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<int>> userBoard;
  late List<List<int>> solution;
  final engine = SudokuEngine();

  int? selectedRow;
  int? selectedCol;
  late List<List<int>> puzzle;
  late int level;

  late DateTime startTime;
  Timer? _timer;
  Duration elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    puzzle = widget.puzzle;
    level = widget.level;
    userBoard = puzzle.map((row) => List<int>.from(row)).toList();
    solution = engine.getSolution(puzzle);
    startTime = DateTime.now();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        elapsedTime = DateTime.now().difference(startTime);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int mins = (duration.inMinutes % 60);
    int secs = (duration.inSeconds % 60);
    
    if (hours > 0) {
      return "$hours:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    }
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void onNumberSelected(int number) {
    if (selectedRow != null && selectedCol != null) {
      if (puzzle[selectedRow!][selectedCol!] == 0) {
        setState(() {
          userBoard[selectedRow!][selectedCol!] = number;
        });
      }
    }
  }

  Color getCellColor(int row, int col) {
    int value = userBoard[row][col];
    if (puzzle[row][col] != 0) return const Color(0xFFEDEDED);
    if (value == 0) return Colors.white;
    if (value == solution[row][col]) return Colors.green.shade200;
    return Colors.red.shade200;
  }

  void checkAndShowResult() {
    bool correct = engine.isCorrect(userBoard, solution);

    if (correct) {
      _timer?.cancel(); //stopping the timer 
    }

    String formattedTime = formatDuration(elapsedTime);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFEDEDED),
        title: Text(correct ? "🎉 Puzzle Solved!" : "❌ Try Again"),
        content: Text(
          correct
              ? "You solved the puzzle in $formattedTime!"
              : "Some numbers are incorrect.",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  Widget buildSudokuGrid() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: List.generate(9, (row) {
        return TableRow(
          children: List.generate(9, (col) {
            bool isSelected = selectedRow == row && selectedCol == col;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRow = row;
                  selectedCol = col;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: getCellColor(row, col),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4F6F52) : Colors.black,
                    width: isSelected ? 2 : 0.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  userBoard[row][col] == 0 ? '' : userBoard[row][col].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: puzzle[row][col] != 0
                        ? Colors.black
                        : const Color(0xFF4F6F52),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF86A789),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F6F52),
        title: Text(
          "Level ${level + 1}",
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildTimerWidget(),
            const SizedBox(height: 16),
            buildSudokuGrid(),
            const SizedBox(height: 20),
            NumberPad(onNumberSelected: onNumberSelected),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkAndShowResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6F52),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer,
            color: Color(0xFF4F6F52),
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            formatDuration(elapsedTime),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F6F52),
              fontFamily: 'Roboto',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumberPad({Key? key, required this.onNumberSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(9, (index) {
        int number = index + 1;
        return GestureDetector(
          onTap: () => onNumberSelected(number),
          child: Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF86A789),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color( 0xFF4F6F52), width: 1.5),
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}