import 'dart:math';


bool isPuzzleSolvable(List<int> puzzle){

  int parity = 0;
  int gridWidth = sqrt(puzzle.length).round();
  int row = 0;
  int blankRow = 0;

  for(int i = 0; i < puzzle.length; i++){
    if(i % gridWidth == 0){
      row++;
    }
    if(puzzle[i] == 0) {
      blankRow = row;
      continue;
    }
    for (int j = i + 1; j < puzzle.length; j++){
      if(puzzle[i] > puzzle[j] && puzzle[j] != 0){
        parity++;
      }
    }
  }

  if(gridWidth % 2 == 0) {
    if(blankRow % 2 == 0) {
      return parity % 2 == 0;
    } else {
      return parity % 2 != 0;
    }
  } else {
    return parity % 2 == 0;
  }
}