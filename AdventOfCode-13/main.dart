import '../utils.dart';

int? findReflectionIndex(List<String> lines) {
  // [0] [1]
  // [0,1] [2, 3]
  // [0, 1, 2] [3, 4, 5]
  // [0, 1, 2, 3] [4, 5, 6, 7]
  // [0, 1, 2, 3, 4] [5, 6, 7, 8, 9]
  // [2 ,3 ,4 ,5] [6, 7, 8, 9]
  // [4, 5, 6] [7, 8, 9]
  // [6, 7] [8, 9]
  // [8] [9]

  for (int iteration = 0; iteration < lines.length - 1; iteration++) {
    int topMaxIndex = (2 * iteration + 1).clamp(0, lines.length - 1);
    int bottomMaxIndex = iteration;
    int topCurrentIndex = topMaxIndex;
    int bottomCurrentIndex = bottomMaxIndex - (topMaxIndex - (iteration + 1));

    for (; bottomCurrentIndex <= bottomMaxIndex; topCurrentIndex--, bottomCurrentIndex++) {
      final currentTopLine = lines[topCurrentIndex];
      final currentBottomLine = lines[bottomCurrentIndex];
      if (currentTopLine != currentBottomLine) {
        break;
      }
    }
    // Lines were identical to the end
    if (bottomCurrentIndex > bottomMaxIndex) {
      return iteration + 1;
    }
  }
  // No reflection found
  return null;
}

int? findVerticalReflectionPosition(List<List<String>> chunk) {
  final List<String> verticalLines = [];
  for (int x = 0; x < chunk[0].length; x++) {
    verticalLines.add(chunk.map((line) {
      return line[x];
    }).join(''));
  }

  return findReflectionIndex(verticalLines);
}

int? findHorizontalReflectionPosition(List<List<String>> chunk) {
  final List<String> horizontalLines = [];
  for (int y = 0; y < chunk.length; y++) {
    horizontalLines.add(chunk[y].join(''));
  }

  return findReflectionIndex(horizontalLines);
}

Future<void> main() async {
  List<String> input = await getInput(fileName: 'input.txt');
  final List<List<String>> chunk = [];
  int sum = 0;
  for (int i = 0; i < input.length; i++) {
    String line = input[i];
    if (line.isEmpty || i == input.length - 1) {
      final verticalScore = findVerticalReflectionPosition(chunk);
      if (verticalScore != null) {
        sum += verticalScore;
      } else {
        final horizontalScore = findHorizontalReflectionPosition(chunk);
        if (horizontalScore != null) {
          sum += horizontalScore * 100;
        }
      }
      chunk.clear();
    } else {
      chunk.add(line.split(''));
    }
  }
  print(sum);
}
