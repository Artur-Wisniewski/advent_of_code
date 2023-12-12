import 'dart:math';

import '../utils.dart';

//--- Day 12: Hot Springs ---

const String OPERATIONAL_SPRING = '.';
const String DAMAGED_SPRING = '#';
const String UNKNOWN = '?';

bool isDamagedSpring(String spring) => spring == DAMAGED_SPRING;

bool isOperationalSpring(String spring) => spring == OPERATIONAL_SPRING;

bool isUnknown(String spring) => spring == UNKNOWN;

bool isSpringRowCorrectPrediction(List<String> springsRowPrediction, List<int> damagedSpringsGroups) {
  int groupCurrentIndex = 0;
  int damagedCount = 0;
  for (int i = 0; i < springsRowPrediction.length; i++) {
    final spring = springsRowPrediction[i];
    if (isDamagedSpring(spring)) {
      if (groupCurrentIndex >= damagedSpringsGroups.length) {
        return false;
      }
      damagedCount++;
      final currentGroup = damagedSpringsGroups[groupCurrentIndex];
      if (damagedCount > currentGroup) {
        return false;
      }
    } else if (isOperationalSpring(spring)) {
      if (damagedCount != 0) {
        final currentGroup = damagedSpringsGroups[groupCurrentIndex];
        if (currentGroup != damagedCount) {
          return false;
        }
        groupCurrentIndex++;
        damagedCount = 0;
      }
    } else {
      Exception('Unknown spring type');
    }
  }
  if ((groupCurrentIndex == damagedSpringsGroups.length && damagedCount == 0) ||
      (damagedCount != 0 && damagedCount == damagedSpringsGroups.last && groupCurrentIndex == damagedSpringsGroups.length - 1)) {
    return true;
  }
  return false;
}

int countAllUknownSpringInRow(List<String> springsRow) {
  int count = 0;
  for (final spring in springsRow) {
    if (isUnknown(spring)) {
      count++;
    }
  }
  return count;
}

List<List<String>> getAllSpringRowVariations(List<String> springsRow) {
  final List<List<String>> variations = [];
  final int countAllUknownSpring = countAllUknownSpringInRow(springsRow);
  final int possibleVariantionsLength = pow(2, countAllUknownSpringInRow(springsRow)).toInt();
  for (int i = 0; i < possibleVariantionsLength; i++) {
    final instruction = i.toRadixString(2).split('').map<bool>((e) => e == '1').toList();
    instruction.insertAll(0, List<bool>.generate(countAllUknownSpring - instruction.length, (index) => false));
    final List<String> variation = [];
    int uknownCount = 0;
    for (final spring in springsRow) {
      if (isUnknown(spring)) {
        if(instruction.length > uknownCount && instruction[uknownCount++]){
          variation.add(DAMAGED_SPRING);
        } else {
          variation.add(OPERATIONAL_SPRING);
        }
      } else {
        variation.add(spring);
      }
    }
    variations.add(variation);
  }
  return variations;
}

int countPossibleVariations(List<String> springsRow, List<int> damagedSpringsGroups) {
  int possibleVariations = 0;
  final List<String> possibleSolutions = [];
  final List<List<String>> variations = getAllSpringRowVariations(springsRow);
  for(final variation in variations){
    if(isSpringRowCorrectPrediction(variation, damagedSpringsGroups)){
      possibleVariations++;
      possibleSolutions.add(variation.join());
    }
  }
  return possibleVariations;
}

Future<void> main() async {
  List<String> input = await getInput(fileName: 'input.txt');
  int possibleVariationsSum = 0;
  for (final String line in input) {
    final [springsRowText, damedSpringsText] = line.split(' ');
    final List<String> springsRow = springsRowText.split('');
    final List<int> damagedSpringsGroups = damedSpringsText.split(',').map((e) => int.parse(e)).toList();
    final int possibleVariations = countPossibleVariations(springsRow, damagedSpringsGroups);
    print('$line :$possibleVariations');
    possibleVariationsSum += possibleVariations;
  }
  print(possibleVariationsSum);
}
