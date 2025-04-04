//backtracking and row col check
class SudokuEngine {
  bool solve(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isValid(board, row, col, num)) {
              board[row][col] = num;
              if (solve(board)) {
                return true;
              }
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool _isValid(List<List<int>> board, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num || board[i][col] == num) {
        return false;
      }
    }

    int startRow = row - row % 3;
    int startCol = col - col % 3;

    for (int i = 0; i < 3; i++) {//3x3 checking
      for (int j = 0; j < 3; j++) {
        if (board[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

   //corrected answer
  List<List<int>> getSolution(List<List<int>> puzzle) {
    List<List<int>> board = puzzle.map((row) => List<int>.from(row)).toList();
    solve(board);
    return board;
  }

  
  bool isCorrect(List<List<int>> userBoard, List<List<int>> solution) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (userBoard[i][j] != solution[i][j]) {
          return false;
        }
      }
    }
    return true;
  }
}
