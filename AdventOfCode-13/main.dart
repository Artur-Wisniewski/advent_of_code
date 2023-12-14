import '../utils.dart';

bool isLinesIdentical(List<bool> line1, List<bool> line2) {
  if (line1.length != line2.length) {
    return false;
  }
  for (int i = 0; i < line1.length; i++) {
    if (line1[i] != line2[i]) {
      return false;
    }
  }
  return true;
}

bool isLinesHasExactlyOneDifference(List<bool> line1, List<bool> line2) {
  if (line1.length != line2.length) {
    return false;
  }
  int differencesCount = 0;
  for (int i = 0; i < line1.length; i++) {
    if (line1[i] != line2[i]) {
      differencesCount++;
    }
    if (differencesCount > 1) {
      return false;
    }
  }
  return differencesCount == 1;
}

List<List<bool>> copyChunk(List<List<bool>> chunk) {
  final List<List<bool>> newChunk = [];
  for (final line in chunk) {
    newChunk.add(List.from(line));
  }
  return newChunk;
}

int? findReflectionIndex(List<List<bool>> chunk, {bool isPart2 = false, int? indexToSkip}) {
  int? indexInPart1;
  if (isPart2) {
    indexInPart1 = findReflectionIndex(chunk);
  }

  for (int iteration = 0; iteration < chunk.length - 1; iteration++) {
    int topCurrentIndex = iteration;
    int bottomCurrentIndex = iteration + 1;
    for (; bottomCurrentIndex < chunk.length && topCurrentIndex >= 0; topCurrentIndex--, bottomCurrentIndex++) {
      if (isPart2) {
        if (isLinesHasExactlyOneDifference(chunk[topCurrentIndex], chunk[bottomCurrentIndex])) {
          final newChunk = copyChunk(chunk);
          newChunk[topCurrentIndex] = List.from(chunk[bottomCurrentIndex]);
          int? index = findReflectionIndex(newChunk, indexToSkip: indexInPart1);
          if (index != null) {
            return index;
          }
          newChunk[topCurrentIndex] = List.from(chunk[topCurrentIndex]);
          newChunk[bottomCurrentIndex] = List.from(chunk[topCurrentIndex]);
          index = findReflectionIndex(newChunk, indexToSkip: indexInPart1);
          if (index != null) {
            return index;
          }
        }
      } else {
        final currentTopLine = chunk[topCurrentIndex];
        final currentBottomLine = chunk[bottomCurrentIndex];
        if (!isLinesIdentical(currentTopLine, currentBottomLine)) {
          break;
        }
      }
    }
    // Lines were identical to the end
    if (!isPart2 && (bottomCurrentIndex == chunk.length || topCurrentIndex == -1) && indexToSkip != (iteration + 1)) {
      return iteration + 1;
    }
  }
  // No reflection found
  return null;
}

int? findVerticalReflectionPosition(List<List<bool>> chunk, {bool isPart2 = false}) {
  final List<List<bool>> verticalLines = [];
  for (int x = 0; x < chunk[0].length; x++) {
    verticalLines.add(chunk.map((line) => line[x]).toList());
  }
  return findReflectionIndex(verticalLines, isPart2: isPart2);
}

int? findHorizontalReflectionPosition(List<List<bool>> chunk, {bool isPart2 = false}) {
  final List<List<bool>> horizontalLines = [];
  for (int y = 0; y < chunk.length; y++) {
    horizontalLines.add(chunk[y]);
  }
  return findReflectionIndex(horizontalLines, isPart2: isPart2);
}

Future<void> main() async {
  List<String> input = await getInput(fileName: 'input.txt');
  final List<List<bool>> chunk = [];
  int sum = 0;
  final scores1 = <int>[];
  final scores2 = <int>[];
  for (final isPart2 in [false, true]) {
    for (int i = 0; i < input.length + 1; i++) {
      String line = '';
      if (i != input.length) {
        line = input[i];
      }
      if (line.isEmpty) {
        final verticalScore = findVerticalReflectionPosition(chunk, isPart2: isPart2);
        if (verticalScore != null) {
          if (isPart2) {
            scores2.add(verticalScore);
          } else {
            scores1.add(verticalScore);
          }
          sum += verticalScore;
        } else {
          final horizontalScore = findHorizontalReflectionPosition(chunk, isPart2: isPart2);
          if (horizontalScore != null) {
            if (isPart2) {
              scores2.add(horizontalScore * 100);
            } else {
              scores1.add(horizontalScore * 100);
            }
            sum += horizontalScore * 100;
          }
        }
        chunk.clear();
      } else {
        chunk.add(line.split('').map((e) => e == '#').toList());
      }
    }
    print('${isPart2 ? 'Part2' : 'Part1'} :$sum');
    sum = 0;
  }
  print('| Part2 |');
  print('| ----- |');
  for (int i = 0; i < scores2.length; i++) {
    print('${scores2[i]}');
  }
}
