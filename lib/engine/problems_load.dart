import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:developer';

import 'package:sudofutter/network/api_service.dart';

class SudokuProblemManager {
  static const _boxName = 'sudoku_puzzles';

  static List<List<List<int>>> sudokuProblems = [];

  static Future<void> init() async {
    final box = await Hive.openBox(_boxName);
    final stored = box.get('problems');

    if (stored != null) {
      sudokuProblems = List<List<List<int>>>.from(
        (stored as List).map((puzzle) =>
          List<List<int>>.from(
            (puzzle as List).map((row) => List<int>.from(row))
          )
        )
      );
      log('✅ Loaded puzzles from Hive: ${sudokuProblems.length}');
    } else {
      sudokuProblems = _fallbackPuzzles;
      await box.put('problems', _fallbackPuzzles);
      log('⚠️ Using fallback puzzles. Hive empty.');
    }
  }


static Future<int> fetchAndAppendNewPuzzles() async {
  final box = await Hive.openBox(_boxName);
  final newPuzzles = await SudokuApiService.fetchPuzzles();

  int added = 0;
  for (var puzzle in newPuzzles) {
    List<List<int>> board = (puzzle as List)
        .map<List<int>>((row) => List<int>.from(row))
        .toList();

    // 🔍 Check deep equality
    bool isDuplicate = sudokuProblems.any((existing) =>
      listEquals(
        existing.expand((e) => e).toList(),
        board.expand((e) => e).toList(),
      )
    );

    if (!isDuplicate) {
      sudokuProblems.add(board);
      added++;
    }
  }

  await box.put('problems', sudokuProblems);
  return added;
}

//hardcoded 4 questions rest from backedn
  static final List<List<List<int>>> _fallbackPuzzles = [
    [
      [5, 3, 0, 0, 7, 0, 0, 0, 0],
      [6, 0, 0, 1, 9, 5, 0, 0, 0],
      [0, 9, 8, 0, 0, 0, 0, 6, 0],
      [8, 0, 0, 0, 6, 0, 0, 0, 3],
      [4, 0, 0, 8, 0, 3, 0, 0, 1],
      [7, 0, 0, 0, 2, 0, 0, 0, 6],
      [0, 6, 0, 0, 0, 0, 2, 8, 0],
      [0, 0, 0, 4, 1, 9, 0, 0, 5],
      [0, 0, 0, 0, 8, 0, 0, 7, 9]
    ],
    [
    [0, 2, 0, 6, 0, 8, 0, 0, 0],
    [5, 8, 0, 0, 0, 9, 7, 0, 0],
    [0, 0, 0, 0, 4, 0, 0, 0, 0],
    [3, 7, 0, 0, 0, 0, 5, 0, 0],
    [6, 0, 0, 0, 0, 0, 0, 0, 4],
    [0, 0, 8, 0, 0, 0, 0, 1, 3],
    [0, 0, 0, 0, 2, 0, 0, 0, 0],
    [0, 0, 9, 8, 0, 0, 0, 3, 6],
    [0, 0, 0, 3, 0, 6, 0, 9, 0]
  ],
  [
    [3, 0, 6, 5, 0, 8, 4, 0, 0],
    [5, 2, 0, 0, 0, 0, 0, 0, 0],
    [0, 8, 7, 0, 0, 0, 0, 3, 1],
    [0, 0, 3, 0, 1, 0, 0, 8, 0],
    [9, 0, 0, 8, 6, 3, 0, 0, 5],
    [0, 5, 0, 0, 9, 0, 6, 0, 0],
    [1, 3, 0, 0, 0, 0, 2, 5, 0],
    [0, 0, 0, 0, 0, 0, 0, 7, 4],
    [0, 0, 5, 2, 0, 6, 3, 0, 0]
  ],
  [
    [0, 0, 0, 2, 6, 0, 7, 0, 1],
    [6, 8, 0, 0, 7, 0, 0, 9, 0],
    [1, 9, 0, 0, 0, 4, 5, 0, 0],
    [8, 2, 0, 1, 0, 0, 0, 4, 0],
    [0, 0, 4, 6, 0, 2, 9, 0, 0],
    [0, 5, 0, 0, 0, 3, 0, 2, 8],
    [0, 0, 9, 3, 0, 0, 0, 7, 4],
    [0, 4, 0, 0, 5, 0, 0, 3, 6],
    [7, 0, 3, 0, 1, 8, 0, 0, 0]
  ],
  ];
}
