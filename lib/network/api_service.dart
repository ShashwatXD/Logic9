// lib/network/sudoku_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sudofutter/constants/base_api.dart';

class SudokuApiService {

  static Future<List<List<List<int>>>> fetchPuzzles() async {
    final response = await http.get(Uri.parse('$base_url/puzzles'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map<List<List<int>>>(
        (puzzle) => (puzzle as List)
            .map<List<int>>((row) => List<int>.from(row))
            .toList(),
      ).toList();
    } else {
      throw Exception('Failed to fetch puzzles from backend');
    }
  }
}
