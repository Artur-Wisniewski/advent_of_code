import 'main.dart';

void main() {
  void testVertical1() {
    // #.##..##.
    // ..#.##.#.
    // ##......#
    // ##......#
    // ..#.##.#.
    // ..##..##.
    // #.#.##.#.

    // vertical: 5
    // horizontal: null
    void test1() {
      // #.##..##.
      // ..#.##.#.
      // ##......#
      // ##......#
      // ..#.##.#.
      // ..##..##.
      // #.#.##.#.
      final List<List<String>> chunk = [
        ['#', '.', '#', '#', '.', '.', '#', '#', '.'],
        ['.', '.', '#', '.', '#', '#', '.', '#', '.'],
        ['#', '#', '.', '.', '.', '.', '.', '.', '#'],
        ['#', '#', '.', '.', '.', '.', '.', '.', '#'],
        ['.', '.', '#', '.', '#', '#', '.', '#', '.'],
        ['.', '.', '#', '#', '.', '.', '#', '#', '.'],
        ['#', '.', '#', '.', '#', '#', '.', '#', '.'],
      ];

      final int? verticalScore = findVerticalReflectionPosition(chunk);
      final int? horizontalScore = findHorizontalReflectionPosition(chunk);
      assert(verticalScore == 5, 'verticalScore: $verticalScore but expected: 5');
      assert(horizontalScore == null, 'horizontalScore: $horizontalScore but expected: null');
    }

    //#...##..#
    // #....#..#
    // ..##..###
    // #####.##.
    // #####.##.
    // ..##..###
    // #....#..#
    // 4
    void test2(){
      //#...##..#
      // #....#..#
      // ..##..###
      // #####.##.
      // #####.##.
      // ..##..###
      // #....#..#
      final List<List<String>> chunk = [
        ['#', '.', '.', '.', '#', '#', '.', '.', '#'],
        ['#', '.', '.', '.', '.', '#', '.', '.', '#'],
        ['.', '.', '#', '#', '.', '.', '#', '#', '#'],
        ['#', '#', '#', '#', '#', '.', '#', '#', '.'],
        ['#', '#', '#', '#', '#', '.', '#', '#', '.'],
        ['.', '.', '#', '#', '.', '.', '#', '#', '#'],
        ['#', '.', '.', '.', '.', '#', '.', '.', '#'],
      ];

      final int? verticalScore = findVerticalReflectionPosition(chunk);
      final int? horizontalScore = findHorizontalReflectionPosition(chunk);
      assert(verticalScore == null, 'verticalScore: $verticalScore but expected: null');
      assert(horizontalScore == 4, 'horizontalScore: $horizontalScore but expected: 4');
    }

    test1();
    test2();
  }

  testVertical1();
}
