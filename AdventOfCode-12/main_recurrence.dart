import '../utils.dart';

// --- Day 12: Hot Springs ---

const String OPERATIONAL_SPRING = '.';
const String DAMAGED_SPRING = '#';
const String UNKNOWN_SPRING = '?';

int numberOfOperations = 0;

int countPossibleVariations(
    List<String> conditionRecords, List<int> damagedSpringsGroups, int index, int groupIndex, int damagedCount) {
  numberOfOperations++;
  bool isDamagedCountIsNotEmptyButGroupsEnded() => damagedCount != 0 && groupIndex == damagedSpringsGroups.length;
  bool isCountIsBiggerThanCurrentGroup() =>
      groupIndex < damagedSpringsGroups.length && damagedCount > damagedSpringsGroups[groupIndex];

  if (isDamagedCountIsNotEmptyButGroupsEnded() || isCountIsBiggerThanCurrentGroup()) {
    return 0;
  }

  if (index == conditionRecords.length) {
    if(groupIndex == damagedSpringsGroups.length - 1 && damagedCount == damagedSpringsGroups.last){
      return 1;
    }
    if(groupIndex == damagedSpringsGroups.length && damagedCount == 0){
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

  return possibleVariationsSum;
}

//
Future<void> main() async {
  final DateTime now = DateTime.now();
  List<String> input = await getInput(fileName: 'input.txt');
  int possibleVariationsSum = 0;
  for (final String line in input) {
    final [springsRowText, damedSpringsText] = line.split(' ');
    final List<String> springsRow = springsRowText.split('');
    final List<int> damagedSpringsGroups = damedSpringsText.split(',').map((e) => int.parse(e)).toList();
    final int possibleVariations = countPossibleVariations(springsRow, damagedSpringsGroups, 0, 0, 0);
    possibleVariationsSum += possibleVariations;
  }
  print('Anser part1: $possibleVariationsSum');
  print('Time execution: ${DateTime.now().difference(now).inMicroseconds} microseconds');
  print('Number of operations: $numberOfOperations');
}
