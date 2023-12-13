import 'main_recurrence.dart';

void main(){

  // ???.### 1,1,3
  // result: 1
  void test1(){
    final inputLine = '???.###'.split('');
    final damagedSpringsGroups = [1,1,3];
    final answer = countPossibleVariations(inputLine, damagedSpringsGroups, 0, 0, 0);
    assert(answer == 1, 'Answer should be 1 but is $answer');
  }

  // .??..??...?##. 1,1,3
  // result: 4
  void test2(){
    final inputLine = '.??..??...?##.'.split('');
    final damagedSpringsGroups = [1,1,3];
    final answer = countPossibleVariations(inputLine, damagedSpringsGroups, 0, 0, 0);
    assert(answer == 4, 'Answer should be 4 but is $answer');
  }

  // ?#?#?#?#?#?#?#? 1,3,1,6
  // result: 1
  void test3(){
    final inputLine = '?#?#?#?#?#?#?#?'.split('');
    final damagedSpringsGroups = [1,3,1,6];
    final answer = countPossibleVariations(inputLine, damagedSpringsGroups, 0, 0, 0);
    assert(answer == 1, 'Answer should be 1 but is $answer');
  }

  // ????.#...#... 4,1,1
  // result: 1
  void test4(){
    final inputLine = '????.#...#...'.split('');
    final damagedSpringsGroups = [4,1,1];
    final answer = countPossibleVariations(inputLine, damagedSpringsGroups, 0, 0, 0);
    assert(answer == 1, 'Answer should be 1 but is $answer');
  }

  // ????.######..#####. 1,6,5
  // result: 4
  void test5(){
    final inputLine = '????.######..#####.'.split('');
    final damagedSpringsGroups = [1,6,5];
    final answer = countPossibleVariations(inputLine, damagedSpringsGroups, 0, 0, 0);
    assert(answer == 4, 'Answer should be 4 but is $answer');
  }

  // ?###???????? 3,2,1
  // result: 10
  void test6(){
    final inputLine = '?###????????'.split('');
    final damagedSpringsGroups = [3,2,1];
    final answer = countPossibleVariations(inputLine, damagedSpringsGroups, 0, 0, 0);
    assert(answer == 10, 'Answer should be 10 but is $answer');
  }

  test1();
  test2();
  test3();
  test4();
  test5();
  test6();
}