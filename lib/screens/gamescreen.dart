import 'dart:async';
import 'dart:ui';
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
  late int level;
  Timer? _timer;
  late DateTime startTime;
  Duration elapsedTime = Duration.zero;
  int mistakeCount = 0;

  @override
  void initState() {
    super.initState();
    level = widget.level;
    userBoard = widget.puzzle.map((row) => List<int>.from(row)).toList();
    solution = engine.getSolution(widget.puzzle);
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

  void onNumberSelected(int number) {
    if (selectedRow != null && selectedCol != null) {
      if (widget.puzzle[selectedRow!][selectedCol!] == 0) {
        setState(() {
          if (userBoard[selectedRow!][selectedCol!] == number) {
            userBoard[selectedRow!][selectedCol!] = 0;
          } else {
            userBoard[selectedRow!][selectedCol!] = number;
            if (number != solution[selectedRow!][selectedCol!]) {
              mistakeCount++;
              if (mistakeCount >= 3) {
                _timer?.cancel();
                showGameOverDialog();
              }
            }
          }
        });
      }
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Game Over 💀"),
        content: const Text("You made 3 mistakes. Try again!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text("Restart!"),
          )
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      userBoard = widget.puzzle.map((row) => List<int>.from(row)).toList();
      selectedRow = null;
      selectedCol = null;
      mistakeCount = 0;
      elapsedTime = Duration.zero;
      _timer?.cancel();
      startTime = DateTime.now();
      startTimer();
    });
  }

  String formatTime(Duration duration) {
    int m = duration.inMinutes.remainder(60);
    int s = duration.inSeconds.remainder(60);
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  bool isSameBlock(int r1, int c1, int r2, int c2) {
    return (r1 ~/ 3 == r2 ~/ 3) && (c1 ~/ 3 == c2 ~/ 3);
  }

  Color getCellColor(int row, int col) {
    if (widget.puzzle[row][col] != 0) return const Color(0xFFEDEDED);
    if (userBoard[row][col] == 0) return Colors.white;
    if (userBoard[row][col] == solution[row][col]) return Colors.green.shade200;
    return Colors.red.shade200;
  }

  void checkResult() {
    bool correct = engine.isCorrect(userBoard, solution);
    _timer?.cancel();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(correct ? "🎉 Puzzle Solved!" : "❌ Try Again"),
        content: Text(correct
            ? "You solved the puzzle in ${formatTime(elapsedTime)}"
            : "Some numbers are incorrect."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget buildGrid() {
    return Table(
      border: TableBorder.all(color: Colors.black),
      children: List.generate(9, (row) {
        return TableRow(
          children: List.generate(9, (col) {
            bool isSelected = selectedRow == row && selectedCol == col;
            bool inSameBlock = selectedRow != null &&
                selectedCol != null &&
                isSameBlock(selectedRow!, selectedCol!, row, col);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedRow = row;
                  selectedCol = col;
                });
              },
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.yellow.shade300
                      : inSameBlock
                          ? Colors.yellow.shade100
                          : getCellColor(row, col),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF4F6F52) : Colors.black45,
                    width: isSelected ? 2 : 0.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  userBoard[row][col] == 0 ? '' : userBoard[row][col].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: widget.puzzle[row][col] != 0
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Level ${level + 1}"),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/gameback.jpg',
            fit: BoxFit.cover,
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 30, 16, 16),
            child: Column(
              children: [
                _topInfoBar(),
                const SizedBox(height: 12),
                buildGrid(),
                const SizedBox(height: 24),
                NumberPad(onNumberSelected: onNumberSelected),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: checkResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 46, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black38,
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Mistakes: $mistakeCount / 3",
              style: const TextStyle(
                color: Color.fromARGB(255, 217, 140, 140),
                fontWeight: FontWeight.w600,
              )),
          Row(
            children: [
              const Icon(Icons.timer, size: 20, color: Colors.black87),
              const SizedBox(width: 5),
              Text(formatTime(elapsedTime),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ],
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
      spacing: 12,
      runSpacing: 12,
      children: List.generate(9, (index) {
        int number = index + 1;
        return GestureDetector(
          onTap: () => onNumberSelected(number),
          child: Container(
            alignment: Alignment.center,
            width: 40,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color.fromARGB(255, 73, 66, 66), 
                width: 2,
              ),
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
