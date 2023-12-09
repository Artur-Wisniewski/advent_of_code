import 'main.dart';

// TDD - Test Driven Development

Future<void> main() async {
  testRangeClass();
}

void testRangeClass() {
  final Range range = Range(start: 4, end: 7);

  void testHasCommonValues() {
    assert(range.hasCommonValues(range: Range(start: 2, end: 4)), 'Range 4-7 has common values with range 2-4');
    assert(!range.hasCommonValues(range: Range(start: 0, end: 2)), 'Range 4-7 has no common values with range 0-2');
    assert(!range.hasCommonValues(range: Range(start: 0, end: 3)), 'Range 4-7 has no common values with range 0-3');
    assert(range.hasCommonValues(range: Range(start: 1, end: 4)), 'Range 4-7 has common values with range 1-4');
    assert(range.hasCommonValues(range: Range(start: 7, end: 10)), 'Range 4-7 has common values with range 7-10');
    assert(!range.hasCommonValues(range: Range(start: 8, end: 10)), 'Range 4-7 has no common values with range 8-10');
  }

  void testShift() {
    assert(range.shift(1).start == 5, 'Range 4-7 shifted by 1 starts at 5');
    assert(range.shift(1).end == 8, 'Range 4-7 shifted by 1 ends at 8');
    assert(range.shift(-1).start == 3, 'Range 4-7 shifted by -1 starts at 3');
    assert(range.shift(-1).end == 6, 'Range 4-7 shifted by -1 ends at 6');
  }

  void testCutOut() {
    void testCase1() {
      //                 CS      CE
      //             RS  |-------|   RE
      //             |---------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 4, end: 7);
      final cutOutRange = Range(start: 5, end: 6);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(before == Range(start: 4, end: 4), 'Range 4-7 cut out by 5-6 should range before: 4-4, but it is $before');
      assert(inter == Range(start: 5, end: 6), 'Range 4-7 cut out by 5-6 should range inter: 5-6, but it is $inter');
      assert(after == Range(start: 7, end: 7), 'Range 4-7 cut out by 5-6 should range after: 7-7, but it is $after');
    }

    void testCase2() {
      //             CS              CE
      //     RS      |-------RE------|
      //     |---------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 2, end: 5);
      final cutOutRange = Range(start: 4, end: 7);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(before == Range(start: 2, end: 3), 'Range 2-5 cut out by 4-7 should range before: 2-3, but it is $before');
      assert(inter == Range(start: 4, end: 5), 'Range 2-5 cut out by 4-7 should range inter: 4-5, but it is $inter');
      assert(after == null, 'Range 2-5 cut out by 4-7 should range after: null, but it is $after');
    }

    void testCase3() {
      //             CS              CE
      //             |---RS----------|       RE
      //                 |-------------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 5, end: 9);
      final cutOutRange = Range(start: 4, end: 7);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(before == null, 'Range 5-9 cut out by 4-7 should range before: null, but it is $before');
      assert(inter == Range(start: 5, end: 7), 'Range 5-9 cut out by 4-7 should range inter: 5-7, but it is $inter');
      assert(after == Range(start: 8, end: 9), 'Range 5-9 cut out by 4-7 should range after: 8-9, but it is $after');
    }

    void testCase4() {
      // CS                                      CE
      // |---------------RS------------------RE--|
      //                 |-------------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 5, end: 9);
      final cutOutRange = Range(start: 0, end: 11);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(before == null, 'Range 5-9 cut out by 0-11 should range before: null, but it is $before');
      assert(inter == Range(start: 5, end: 9), 'Range 5-9 cut out by 0-11 should range inter: 5-9, but it is $inter');
      assert(after == null, 'Range 5-9 cut out by 0-11 should range after: null, but it is $after');
    }

    void testCase5() {
      //                                     CS     CE
      //                 RS              RE  |-------|
      //                 |---------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 5, end: 9);
      final cutOutRange = Range(start: 10, end: 11);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(
          before == Range(start: 5, end: 9), 'Range 5-9 cut out by 10-11 should range before: 5-9, but it is $before');
      assert(inter == null, 'Range 5-9 cut out by 10-11 should range inter: null, but it is $inter');
      assert(after == null, 'Range 5-9 cut out by 10-11 should range after: null, but it is $after');
    }

    void testCase6() {
      // CS          CE
      // |-----------|   RS                  RE
      //                 |-------------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 5, end: 9);
      final cutOutRange = Range(start: 1, end: 3);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(before == null, 'Range 5-9 cut out by 1-3 should range before: null, but it is $before');
      assert(inter == null, 'Range 5-9 cut out by 1-3 should range inter: null, but it is $inter');
      assert(after == Range(start: 5, end: 9), 'Range 5-9 cut out by 1-3 should range after: 5-9, but it is $after');
    }

    void testCase7() {
      //                            CS          CE
      // RS                  RE      |-----------|
      // |-------------------|
      // | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |
      final range = Range(start: 1, end: 5);
      final cutOutRange = Range(start: 8, end: 10);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(
          before == Range(start: 1, end: 5), 'Range 1-5 cut out by 8-10 should range before: 1-5, but it is $before');
      assert(inter == null, 'Range 1-5 cut out by 8-10 should range inter: null, but it is $inter');
      assert(after == null, 'Range 1-5 cut out by 8-10 should range after: null, but it is $after');
    }

    void testCase8SingleValues() {
      //         CS          CE
      //         |---RS--RE--|
      //             |---|
      // | 1 | 2 | 3 | 4 | 5 | 6 |
      final range = Range.singleValue(value: 4);
      final cutOutRange = Range(start: 3, end: 5);
      final (before, inter, after) = range.cutOut(range: cutOutRange);
      assert(before == null, 'Range 4-4 cut out by 3-5 should range before: null, but it is $before');
      assert(
          inter == Range.singleValue(value: 4), 'Range 4-4 cut out by 3-5 should range inter: 4-4, but it is $inter');
      assert(after == null, 'Range 4-4 cut out by 3-5 should range after: null, but it is $after');
    }

    testCase1();
    testCase2();
    testCase3();
    testCase4();
    testCase5();
    testCase6();
    testCase7();
    testCase8SingleValues();
  }

  testHasCommonValues();
  testShift();
  testCutOut();
}
