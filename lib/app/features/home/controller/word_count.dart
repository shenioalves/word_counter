int countWord(List<List<String>> matrix, String word) {
  final int row = matrix.length;
  final int column = matrix[0].length;
  final wordLength = word.length;
  int count = 0;
  // Se a palavra for vazia ou a matriz estiver vazia, retorna 0
  if (word.isEmpty || matrix.isEmpty || matrix[0].isEmpty) {
    return 0;
  }

  // 8 direcoes possiveis [x, y]
  const directions = [
    [-1, -1], [-1, 0], [-1, 1], // diagonal, cima, diagonal
    [0, -1],           [0, 1], // esquerda,        direita
    [1, -1],  [1, 0],  [1, 1], // diagonal, baixo, diagonal
  ];

  // percorre a matriz
  for (int i = 0; i < row; i++) {
    for (int j = 0; j < column; j++) {
      // verifica se é a primeira letra da palavra
      if (matrix[i][j] == word[0]) {
        // verifica todas as direcoess possiveis
        for (final direction in directions) {
          final dirRow = direction[0];
          final dirCol = direction[1];
          bool match = true;

          // verifica as letras subsequentes na direção atual
          for (int k = 1; k < wordLength; k++) {
            final newRow = i + k * dirRow;
            final newCol = j + k * dirCol;

            // verifica se esta dentro dos limites da matriz
            if (newRow < 0 || newCol < 0 || newRow >= matrix.length || newCol >= matrix[newRow].length) {
              match = false;
              break;
            }

            // verifica se a letra corresponde
            if (matrix[newRow][newCol] != word[k]) {
              match = false;
              break;
            }
          }
          // encontra a palavra
          if (match) {
            count++;
          }
        }
      }
    }
  }

  return count;
}
