import 'package:flutter/material.dart';
import 'package:sudofutter/UiUtils/UiUtils.dart';
import 'package:sudofutter/engine/problems_load.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({Key? key}) : super(key: key);

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  List<List<List<int>>> get sudokuProblems => SudokuProblemManager.sudokuProblems;

  
  Future<void> _checkForNewPuzzles() async {
  UIUtils.showLoadingWithTimeout(context, message: "Checking for new puzzles...");

  try {
print("Total puzzles before: ${SudokuProblemManager.sudokuProblems.length}");
final added = await SudokuProblemManager.fetchAndAppendNewPuzzles();
print("Added: $added");
print("Total puzzles after: ${SudokuProblemManager.sudokuProblems.length}");
    UIUtils.hideLoading(context);

    if (added > 0) {
      UIUtils.showToast(context, "$added new puzzles added!");
    } else {
      UIUtils.showSnackbar(context, "No new puzzles available.");
    }

    setState(() {}); 
  } catch (e) {
    UIUtils.hideLoading(context);
    UIUtils.showSnackbar(context, "Error fetching puzzles.");
    debugPrint("Error: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF86A789),
        title: const Text('Select A Level'),
        elevation: 5,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: _checkForNewPuzzles,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sudokuProblems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/game',
                          arguments: {
                            'level': index,
                            'puzzle': sudokuProblems[index],
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF86A789),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 4),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Level ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
