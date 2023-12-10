import 'main.dart';

void main() {
  void predictionTestPart1(){
    // 1 2 3 4 5
    // expected: 6
    void test1(){
      final List<int> values = [1, 2, 3, 4, 5];
      final int expected = 6;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    // 1 3 6 10 15
    // expected: 21
    void test2(){
      final List<int> values = [1, 3, 6, 10, 15];
      final int expected = 21;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    // 1 3 6 10 15 21
    // expected: 28
    void test3(){
      final List<int> values = [1, 3, 6, 10, 15, 21];
      final int expected = 28;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    // 10 13 16 21 30 45
    // expected: 68
    void test4(){
      final List<int> values = [10, 13, 16, 21, 30, 45];
      final int expected = 68;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    // -8 12 33 55 78 102
    // expected: 127
    void test5(){
      final List<int> values = [-8, 12, 33, 55, 78, 102];
      final int expected = 127;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    // 2 1 -3 -10 -20 -33 -49 -68 -90 -115 -143 -174 -208 -245 -285 -328 -374 -423 -475 -530 -588
    // expected: -649
    void test6(){
      final List<int> values = [2, 1, -3, -10, -20, -33, -49, -68, -90, -115, -143, -174, -208, -245, -285, -328, -374, -423, -475, -530, -588];
      final int expected = -649;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    //-2 6 32 90 203 421 863 1799 3804 8041 16764 34188 67988 131949 250881 470219 875478 1632236 3067792 5834670 11229253
    // expected: 21794305
    void test7(){
      final List<int> values = [-2, 6, 32, 90, 203, 421, 863, 1799, 3804, 8041, 16764, 34188, 67988, 131949, 250881, 470219, 875478, 1632236, 3067792, 5834670, 11229253];
      final int expected = 21794305;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    //9 3 -4 6 66 226 561 1193 2351 4518 8760 17435 35714 74856 159260 341577 734834 1580026 3386666 7221320 15292153
    //32117577
    void test8(){
      final List<int> values = [9, 3, -4, 6, 66, 226, 561, 1193, 2351, 4518, 8760, 17435, 35714, 74856, 159260, 341577, 734834, 1580026, 3386666, 7221320, 15292153];
      final int expected = 32117577;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    //10 24 34 42 67 169 489 1304 3092 6596 12866 23238 39178 61916 91984 129612 179482 269732 509310 1236682 3367793
    // 9149807
    void test9(){
      final List<int> values = [10, 24, 34, 42, 67, 169, 489, 1304, 3092, 6596, 12866, 23238, 39178, 61916, 91984, 129612, 179482, 269732, 509310, 1236682, 3367793];
      final int expected = 9149807;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }
    //14 24 45 77 120 174 239 315 402 500 609 729 860 1002 1155 1319 1494 1680 1877 2085 2304
    // 2534
    void test10(){
      final List<int> values = [14, 24, 45, 77, 120, 174, 239, 315, 402, 500, 609, 729, 860, 1002, 1155, 1319, 1494, 1680, 1877, 2085, 2304];
      final int expected = 2534;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    //17 32 49 71 122 274 689 1683 3826 8101 16156 30696 56077 99181 170670 286738 471503 760206 1203411 1872429 2866220
    // 4320060
    void test11(){
      final List<int> values = [17, 32, 49, 71, 122, 274, 689, 1683, 3826, 8101, 16156, 30696, 56077, 99181, 170670, 286738, 471503, 760206, 1203411, 1872429, 2866220];
      final int expected = 4320060;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    //10 23 42 70 110 165 238 332 450 595 770 978 1222 1505 1830 2200 2618 3087 3610 4190 4830
    // 5533
    void test12(){
      final List<int> values = [10, 23, 42, 70, 110, 165, 238, 332, 450, 595, 770, 978, 1222, 1505, 1830, 2200, 2618, 3087, 3610, 4190, 4830];
      final int expected = 5533;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    //10 17 20 12 -4 11 184 822 2558 6565 14852 30656 58944 107039 185384 308458 495858 773561 1175380 1744628 2536004
    // 3617715
    void test13(){
      final List<int> values = [10, 17, 20, 12, -4, 11, 184, 822, 2558, 6565, 14852, 30656, 58944, 107039, 185384, 308458, 495858, 773561, 1175380, 1744628, 2536004];
      final int expected = 3617715;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }
    //17 41 73 111 166 284 585 1324 2979 6371 12821 24349 43920 75742 125621 201378 313333 474861 703025 1019291 1450330
    // 2028912
    void test14(){
      final List<int> values = [17, 41, 73, 111, 166, 284, 585, 1324, 2979, 6371, 12821, 24349, 43920, 75742, 125621, 201378, 313333, 474861, 703025, 1019291, 1450330];
      final int expected = 2028912;
      final int actual = predictNextValue(values);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
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

  void predictionTestPart2(){
    // 10  13  16  21  30  45
    // 5
    void test1(){
      final List<int> values = [10, 13, 16, 21, 30, 45];
      final int expected = 5;
      final int actual = predictNextValue(values, directionForward: false);
      assert(expected == actual, 'Expected: $expected, Actual: $actual');
    }

    test1();
  }

  predictionTestPart1();
  predictionTestPart2();
}
