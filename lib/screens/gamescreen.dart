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

  @override
  void initState() {
    super.initState();
    puzzle = widget.puzzle;
    level = widget.level;
    userBoard = puzzle.map((row) => List<int>.from(row)).toList();
    
    // Generate solution using the getSolution method from SudokuEngine
    solution = engine.getSolution(puzzle);
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

    if (puzzle[row][col] != 0) return Colors.grey.shade300;
    if (value == 0) return Colors.white;
    if (value == solution[row][col]) return Colors.green.shade200;
    return Colors.red.shade200;
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
                    color: isSelected ? Colors.blue : Colors.black,
                    width: isSelected ? 2 : 0.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  userBoard[row][col] == 0 ? '' : userBoard[row][col].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: puzzle[row][col] != 0
                        ? Colors.black
                        : Colors.blueAccent,
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  void checkAndShowResult() {
    bool correct = engine.isCorrect(userBoard, solution);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(correct ? "🎉 Correct!" : "❌ Try Again"),
        content: Text(
          correct ? "You solved the puzzle!" : "Some numbers are incorrect.",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${level + 1} - Logic9"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildSudokuGrid(),
            const SizedBox(height: 20),
            NumberPad(onNumberSelected: onNumberSelected),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: checkAndShowResult,
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  final Function(int) onNumberSelected;

  const NumberPad({Key? key, required this.onNumberSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(9, (index) {
        int number = index + 1;
        return GestureDetector(
          onTap: () => onNumberSelected(number),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }
}