//--- Day 9: Mirage Maintenance ---

import '../utils.dart';
import 'dart:core';

int predictNextValue(List<int> values, {bool directionForward = true}) {
  if (values.every((element) => element == values.first)) {
    return values.first;
  }
  final List<int> differences = [];
  for (int i = 0; i < values.length - 1; i++) {
    differences.add(values[i + 1] - values[i]);
  }
  if (directionForward) {
    return values.last + predictNextValue(differences, directionForward: directionForward);
  } else {
    return values.first - predictNextValue(differences, directionForward: directionForward);
  }
}

Future<void> main() async {
  final inputLines = await getInput(fileName: 'input.txt');
  int sum = 0;
  int sumPart2 = 0;
  for (final line in inputLines) {
    final List<int> values = line.split(' ').map((e) => int.parse(e)).toList();
    sum += predictNextValue(values, directionForward: true);
    sumPart2 += predictNextValue(values, directionForward: false);
  }
  print('PART1: Sum of all numbers: $sum');
  print('PART2: Sum of all numbers: $sumPart2');
}
