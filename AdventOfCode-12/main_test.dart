import 'main.dart';

void main() {
  void testSpringsRowPrediction() {
    // #.#.### 1,1,3
    // correct
    void test1() {
      final List<String> springsRowPrediction = ['#', '.', '#', '.', '#', '#', '#'];
      final List<int> damagedSpringsGroups = [1, 1, 3];
      assert(isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '#.#.### 1,1,3 Should be correct but is not!');
    }

    // .#...#....###. 1,1,3
    // correct
    void test2() {
      final List<String> springsRowPrediction = [
        '.',
        '#',
        '.',
        '.',
        '.',
        '#',
        '.',
        '.',
        '.',
        '.',
        '#',
        '#',
        '#',
        '.',
        '.',
        '.'
      ];
      final List<int> damagedSpringsGroups = [1, 1, 3];
      assert(isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '.#...#....###. 1,1,3 Should be correct but is not!');
    }

    //.#.###.#.###### 1,3,1,6
    // correct
    void test3() {
      final List<String> springsRowPrediction = [
        '.',
        '#',
        '.',
        '#',
        '#',
        '#',
        '.',
        '#',
        '.',
        '#',
        '#',
        '#',
        '#',
        '#',
        '#'
      ];
      final List<int> damagedSpringsGroups = [1, 3, 1, 6];
      assert(isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '.#.###.#.###### 1,3,1,6 Should be correct but is not!');
    }

    // ####.#...#... 4,1,1
    // correct
    void test4() {
      final List<String> springsRowPrediction = ['#', '#', '#', '#', '.', '#', '.', '.', '.', '#', '.', '.', '.'];
      final List<int> damagedSpringsGroups = [4, 1, 1];
      assert(isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '####.#...#... 4,1,1 Should be correct but is not!');
    }

    // #....######..#####. 1,6,5
    // correct
    void test5() {
      final List<String> springsRowPrediction = [
        '#',
        '.',
        '.',
        '.',
        '.',
        '#',
        '#',
        '#',
        '#',
        '#',
        '#',
        '.',
        '#',
        '#',
        '#',
        '#',
        '#',
        '.'
      ];
      final List<int> damagedSpringsGroups = [1, 6, 5];
      assert(isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '#....######..#####. 1,6,5 Should be correct but is not!');
    }

    // .###.##....# 3,2,1
    // correct
    void test6() {
      final List<String> springsRowPrediction = ['.', '#', '#', '#', '.', '#', '#', '.', '.', '.', '.', '#'];
      final List<int> damagedSpringsGroups = [3, 2, 1];
      assert(isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '.###.##....# 3,2,1 Should be correct but is not!');
    }

    // #...### 1,1,3
    // incorrect
    void test7() {
      final List<String> springsRowPrediction = ['#', '.', '.', '.', '#', '#', '#'];
      final List<int> damagedSpringsGroups = [1, 1, 3];
      assert(!isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '#...### 1,1,3 Should be incorrect but is true!');
    }

    // .....#....###. 1,1,3
    // incorrect
    void test8() {
      final List<String> springsRowPrediction = [
        '.',
        '.',
        '.',
        '.',
        '.',
        '#',
        '.',
        '.',
        '.',
        '.',
        '#',
        '#',
        '#',
        '.',
        '.',
        '.'
      ];
      final List<int> damagedSpringsGroups = [1, 1, 3];
      assert(!isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '.....#....###. 1,1,3 Should be incorrect but is true!');
    }

    // ...###.#.###### 1,3,1,6
    // incorrect
    void test9() {
      final List<String> springsRowPrediction = [
        '.',
        '.',
        '.',
        '#',
        '#',
        '#',
        '.',
        '#',
        '.',
        '#',
        '#',
        '#',
        '#',
        '#',
        '#'
      ];
      final List<int> damagedSpringsGroups = [1, 3, 1, 6];
      assert(!isSpringRowCorrectPrediction(springsRowPrediction, damagedSpringsGroups),
          '...###.#.###### 1,3,1,6 Should be incorrect but is true!');
    }

    //#...#.#.#..#.##### 1,1,1,1,1,5
    // correct
    void test10() {
      final String input = '#...#.#.#..#.#####';
      final List<int> damagedSpringsGroups = [1, 1, 1, 1, 1, 5];
      assert(isSpringRowCorrectPrediction(input.split(''), damagedSpringsGroups),
          '#...#.#.#..#.##### 1,1,1,1,1,5 Should be correct but is not!');
    }
    //#...#.#.#...###### 1,1,1,1,1,5
    // incorrect
    void test11() {
      final String input = '#...#.#.#...######';
      final List<int> damagedSpringsGroups = [1, 1, 1, 1, 1, 5];
      assert(!isSpringRowCorrectPrediction(input.split(''), damagedSpringsGroups),
      '#...#.#.#...###### 1,1,1,1,1,5 Should be correct!');
    }

    //..#.#####.....# 1,5,2
    // incorrect
    void test12() {
      final String input = '..#.#####.....#';
      final List<int> damagedSpringsGroups = [1, 5, 2];
      assert(!isSpringRowCorrectPrediction(input.split(''), damagedSpringsGroups),
      '..#.#####.....# 1,5,2 Should be incorrect!');
    }

    //.#..#####.....# 1,5,2
    // incorrect
    void test13() {
      final String input = '.#..#####.....#';
      final List<int> damagedSpringsGroups = [1, 5, 2];
      assert(!isSpringRowCorrectPrediction(input.split(''), damagedSpringsGroups),
      '.#..#####.....# 1,5,2 Should be incorrect!');
    }

    //#...#####.....#
    // incorrect
    void test14() {
      final String input = '#...#####.....#';
      final List<int> damagedSpringsGroups = [1, 5, 2];
      assert(!isSpringRowCorrectPrediction(input.split(''), damagedSpringsGroups),
      '#...#####.....# 1,5,2 Should be incorrect!');
    }

    test1();
    test2();
    test3();
    test4();
    test5();
    test6();
    test7();
    test8();
    test9();
    test10();
    test11();
    test12();
    test13();
    test14();
  }

  void testAllPossibleVariations() {
    void test1() {
      final List<String> springsRowPrediction = ['.', '?', '?', '.', '.', '?', '?', '.', '.', '.', '?', '#', '#', '.'];
      final variations = getAllSpringRowVariations(springsRowPrediction);
      assert(variations.length == 32, '.??..??...?##. 1,1,3 Should be 32 but is ${variations.length}!');
      final List<String> variationsStrings = variations.map((e) => e.join()).toList();
      final variationsStringsCopy = List.from(variationsStrings);
      for (final variation in variationsStrings) {
        variationsStringsCopy.remove(variation);
        final isDuplicate = variationsStringsCopy.any((element) => element == variation);
        assert(!isDuplicate, '.??..??...?##. 1,1,3 Should not contain duplicates!');
        variationsStringsCopy.add(variation);
      }
    }

    // ??..#????.???????? 1,1,1,1,1,5
    void test2(){
      final List<String> springsRowPrediction = '??..#????.????????'.split('').toList();
      final variations = getAllSpringRowVariations(springsRowPrediction);
      assert(variations.length == 16384, '??..#????.???????? 1,1,1,1,1,5 Should be 16384 but is ${variations.length}!');
      final List<String> variationsStrings = variations.map((e) => e.join()).toList();
      final variationsStringsCopy = List.from(variationsStrings);
      for (final variation in variationsStrings) {
        variationsStringsCopy.remove(variation);
        final isDuplicate = variationsStringsCopy.any((element) => element == variation);
        assert(!isDuplicate, '??..#????.???????? 1,1,3 Should not contain duplicates!');
        variationsStringsCopy.add(variation);
      }
    }

    //.???#???.??# 7,1
    void test3(){
      final List<String> springsRowPrediction = '.???#???.??#'.split('').toList();
      final variations = getAllSpringRowVariations(springsRowPrediction);
      assert(variations.length == 256, '.???#???.??# 7,1 Should be 256 but is ${variations.length}!');
      final List<String> variationsStrings = variations.map((e) => e.join()).toList();
      final variationsStringsCopy = List.from(variationsStrings);
      for (final variation in variationsStrings) {
        variationsStringsCopy.remove(variation);
        final isDuplicate = variationsStringsCopy.any((element) => element == variation);
        assert(!isDuplicate, '.???#???.??# 7,1 Should not contain duplicates!');
        variationsStringsCopy.add(variation);
      }
    }

    // ????#??##.????? 1,5,2
    // 2^11 = 2048
    void test4(){
      final List<String> springsRowPrediction = '????#??##.?????'.split('').toList();
      final variations = getAllSpringRowVariations(springsRowPrediction);
      assert(variations.length == 2048, '????#??##.????? 1,5,2 Should be 2048 but is ${variations.length}!');
      final List<String> variationsStrings = variations.map((e) => e.join()).toList();
      final variationsStringsCopy = List.from(variationsStrings);
      for (final variation in variationsStrings) {
        variationsStringsCopy.remove(variation);
        final isDuplicate = variationsStringsCopy.any((element) => element == variation);
        assert(!isDuplicate, '????#??##.????? 1,5,2 Should not contain duplicates!');
        variationsStringsCopy.add(variation);
      }
    }


    test1();
    test2();
    test3();
    test4();
  }

  void testCountPossibleVariations() {
    // ???.### 1,1,3
    // 1
    void test1() {
      final List<String> springsRowPrediction = ['?', '?', '?', '.', '#', '#', '#'];
      final List<int> damagedSpringsGroups = [1, 1, 3];
      final count = countPossibleVariations(springsRowPrediction, damagedSpringsGroups);
      assert(count == 1, '???.### 1,1,3 Should be 1 but is $count!');
    }

    // .??..??...?##. 1,1,3
    // 4
    // ..#...#...###.
    // .#...#....###.
    // .#....#...###.
    // ..#..#....###.
    void test2() {
      final List<String> springsRowPrediction = ['.', '?', '?', '.', '?', '?', '.', '.', '.', '?', '#', '#', '.'];
      final List<int> damagedSpringsGroups = [1, 1, 3];
      final count = countPossibleVariations(springsRowPrediction, damagedSpringsGroups);
      assert(count == 4, '.??..??...?##. 1,1,3 Should be 4 but is $count!');
    }

    // ?????.?##?? 1,1,4
    // 12
    void test3() {
      final List<String> springsRowPrediction = ['?', '?', '?', '?', '?', '.', '?', '#', '#', '?', '?'];
      final List<int> damagedSpringsGroups = [1, 1, 4];
      final count = countPossibleVariations(springsRowPrediction, damagedSpringsGroups);
      assert(count == 12, '?????.?##?? 1,1,4 Should be 12 but is $count!');
    }

    // .???#???.??# 7,1
    // 1
    void test4() {
      final List<String> springsRowPrediction = ['.', '?', '?', '?', '#', '?', '?', '?', '.', '?', '?', '#'];
      final List<int> damagedSpringsGroups = [7, 1];
      final count = countPossibleVariations(springsRowPrediction, damagedSpringsGroups);
      assert(count == 1, '.???#???.??# 7,1 Should be 1 but is $count!');
    }


    // ????#??##.????? 1,5,2
    // 3 * 4 = 12
    void test5() {
      final List<String> springsRowPrediction = '????#??##.?????'.split('').toList();
      final List<int> damagedSpringsGroups = [1, 5, 2];
      final count = countPossibleVariations(springsRowPrediction, damagedSpringsGroups);
      assert(count == 12, '????#??##.????? 1,5,2 Should be 12 but is $count!');
    }


    test1();
    test2();
    test3();
    test4();
    test5();
  }

  testSpringsRowPrediction();
  testAllPossibleVariations();
  testCountPossibleVariations();
}
