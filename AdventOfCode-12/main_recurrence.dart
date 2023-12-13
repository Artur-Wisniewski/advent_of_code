import '../utils.dart';

// --- Day 12: Hot Springs ---

const String OPERATIONAL_SPRING = '.';
const String DAMAGED_SPRING = '#';
const String UNKNOWN_SPRING = '?';

int numberOfOperations = 0;

Map<(int, int, int), int> cache = {};

int countPossibleVariations(
    List<String> conditionRecords, List<int> damagedSpringsGroups, int index, int groupIndex, int damagedCount) {
  numberOfOperations++;
  bool isDamagedCountIsNotEmptyButGroupsEnded() => damagedCount != 0 && groupIndex == damagedSpringsGroups.length;
  bool isCountIsBiggerThanCurrentGroup() =>
      groupIndex < damagedSpringsGroups.length && damagedCount > damagedSpringsGroups[groupIndex];

  if(cache.containsKey((index, groupIndex, damagedCount))){
    return cache[(index, groupIndex, damagedCount)]!;
  }

  if (isDamagedCountIsNotEmptyButGroupsEnded() || isCountIsBiggerThanCurrentGroup()) {
    return 0;
  }

  if (index == conditionRecords.length) {
    if (groupIndex == damagedSpringsGroups.length - 1 && damagedCount == damagedSpringsGroups.last) {
      return 1;
    }
    if (groupIndex == damagedSpringsGroups.length && damagedCount == 0) {
      return 1;
    }
    return 0;
  }

  // Declarations
  int checkNextSpring() => countPossibleVariations(conditionRecords, damagedSpringsGroups, index + 1, groupIndex, 0);

  int checkNextDamagedGroup() {
    if (damagedCount == damagedSpringsGroups[groupIndex]) {
      return countPossibleVariations(conditionRecords, damagedSpringsGroups, index + 1, groupIndex + 1, 0);
    }
    return 0;
  }

  int checkNextDamagedSpring() =>
      countPossibleVariations(conditionRecords, damagedSpringsGroups, index + 1, groupIndex, damagedCount + 1);

  final String currentSpring = conditionRecords[index];
  int possibleVariationsSum = 0;
  if (currentSpring == UNKNOWN_SPRING) {
    for (final assumptionSpring in [OPERATIONAL_SPRING, DAMAGED_SPRING]) {
      if (assumptionSpring == OPERATIONAL_SPRING) {
        if (damagedCount != 0) {
          possibleVariationsSum += checkNextDamagedGroup();
        } else {
          possibleVariationsSum += checkNextSpring();
        }
      } else if (assumptionSpring == DAMAGED_SPRING) {
        possibleVariationsSum += checkNextDamagedSpring();
      }
    }
  } else {
    if (currentSpring == OPERATIONAL_SPRING) {
      if (damagedCount != 0) {
        possibleVariationsSum += checkNextDamagedGroup();
      } else {
        possibleVariationsSum += checkNextSpring();
      }
    } else if (currentSpring == DAMAGED_SPRING) {
      possibleVariationsSum += checkNextDamagedSpring();
    }
  }

  cache[(index, groupIndex, damagedCount)] = possibleVariationsSum;
  return possibleVariationsSum;
}

Future<void> main() async {
  List<String> input = await getInput(fileName: 'input.txt');
  for (final isPart2 in [true, false]) {
    final DateTime now = DateTime.now();
    numberOfOperations = 0;
    int possibleVariationsSum = 0;
    for (final String line in input) {
      var [springsRowText, damagedSpringsText] = line.split(' ');
      late final List<String> springsRow;
      late final List<int> damagedSpringsGroups;
      if (isPart2) {
        springsRow = List<String>.generate(5, (index) => springsRowText).join(UNKNOWN_SPRING).split('');
        damagedSpringsGroups = List<String>.generate(5, (index) => damagedSpringsText)
            .join(',')
            .split(',')
            .map((e) => int.parse(e))
            .toList();
      } else {
        springsRow = springsRowText.split('');
        damagedSpringsGroups = damagedSpringsText.split(',').map((e) => int.parse(e)).toList();
      }
      cache.clear();
      final int possibleVariations = countPossibleVariations(springsRow, damagedSpringsGroups, 0, 0, 0);
      possibleVariationsSum += possibleVariations;
    }
    print('part${isPart2 ? '2' : '1'}');
    print('Answer: $possibleVariationsSum');
    print('Time execution: ${DateTime.now().difference(now).inMicroseconds} microseconds');
    print('Number of operations: $numberOfOperations');
  }
}
