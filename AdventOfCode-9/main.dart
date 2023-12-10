//--- Day 9: Mirage Maintenance ---

import '../utils.dart';
import 'dart:core';

int predictNextValue(List<int> values) {
  if (values.every((element) => element == values.first)) {
    return values.first;
  }
  final List<int> differences = [];
  for (int i = 0; i < values.length - 1; i++) {
    differences.add(values[i + 1] - values[i]);
  }
  return values.last + predictNextValue(differences);
}

Future<void> main() async {
  final inputLines = await getInput(fileName: 'input.txt');
  int sum = 0;
  for (final line in inputLines) {
    final List<int> values = line.split(' ').map((e) => int.parse(e)).toList();
    final prediction = predictNextValue(values);
    sum += prediction;
    print(sum);
  }
  print('PART1: Sum of all numbers: $sum');
}
