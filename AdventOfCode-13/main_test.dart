import 'main.dart';

void main() {

  test1() {
    final List<String> chunkText = [
      '##.#..#####.#',//
      '##.#..#####.#',//
      '#......#.#..#',//
      '##..##......#',//
      '..###....#.#.',//
      '...###.#.#.##',//
      '#.#.##..##.##',//
      '#.#.#...##.##',//
      '...###.#.#.##',//
    ];
    List<List<bool>> chunk = [];
    for(int i = 0; i < chunkText.length; i++) {
      chunk.add(chunkText[i].split('').map((e) => e == '#').toList());
    }

    final score1 = findHorizontalReflectionPosition(chunk, isPart2: false);
    final score2 = findHorizontalReflectionPosition(chunk, isPart2: true);
    assert(score1 == 1, 'score1: $score1 but should be 1');
    assert(score2 == 7, 'score2: $score2 but should be 7');
  }

  test2(){
    final List<String> chunkText = [
      '..##..#.#.##.#.',//
      '#..#..##.#..#.#',//
      '######..######.',//
      '..#####........',//
      '######.##.##.##',//
      '######.##.##.##',//
      '..#####........',//
      '######..######.',//
      '#.....##.#..#.#',//
    ];
    List<List<bool>> chunk = [];
    for(int i = 0; i < chunkText.length; i++) {
      chunk.add(chunkText[i].split('').map((e) => e == '#').toList());
    }
    int? score2 = findVerticalReflectionPosition(chunk, isPart2: true);
    assert(score2 == null, 'score2: $score2 but should be null');
    score2 = findHorizontalReflectionPosition(chunk, isPart2: true);
    assert(score2 == 5, 'score2: $score2 but should be 500');
  }

  test1();
  test2();
}
