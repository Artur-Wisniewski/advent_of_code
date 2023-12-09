import 'dart:math';

import '../utils.dart';

///--- Day 5: If You Give A Seed A Fertilizer ---
class GardenPlan {
  final List<Range> seeds;
  final List<List<Instruction>> instructionsMap;

  GardenPlan({required this.seeds, required this.instructionsMap});

  factory GardenPlan.fromText({required List<String> lines, bool isPart2 = true}) {
    var [_, seedsText] = lines[0].split(':');
    final List<int> seedsData = seedsText.trim().split(' ').map((e) => int.parse(e)).toList();
    final List<Range> seeds = [];
    if (!isPart2) {
      seeds.addAll(seedsData.map((value) => Range.singleValue(value: value)).toList());
    } else {
      for (int i = 0; i < seedsData.length; i += 2) {
        seeds.add(Range(start: seedsData[i], end: seedsData[i] + seedsData[i + 1] - 1));
      }
    }
    final List<List<Instruction>> instructionsMap = [];
    for (final line in lines.sublist(1)) {
      if (line.contains(':')) {
        instructionsMap.add([]);
      } else if (line.isNotEmpty) {
        instructionsMap.last.add(Instruction.fromLine(line));
      }
    }
    return GardenPlan(seeds: seeds, instructionsMap: instructionsMap);
  }

  int getMinLocationInGarden() {
    final locations = seeds.map((seed) => getMinLocationFor(seed: seed)).toList();
    return minList(locations);
  }

  int getMinLocationFor({required Range seed}) {
    List<Range> rangesToTest = [];
    List<Range> nextInstructionRangesToTest = [];
    List<Range> nextInstructionsGroupRangesToTest = [seed];
    for (final instructions in instructionsMap) {
      nextInstructionRangesToTest = List.from(nextInstructionsGroupRangesToTest);
      nextInstructionsGroupRangesToTest.clear();
      for (final instruction in instructions) {
        rangesToTest = List.from(nextInstructionRangesToTest);
        nextInstructionRangesToTest.clear();
        while (rangesToTest.isNotEmpty) {
          final range = rangesToTest.removeAt(0);
          final (before, inter, after) = range.cutOut(range: instruction.sourceRange);
          if (inter != null) {
            nextInstructionsGroupRangesToTest.add(inter.shift(instruction.sourceDestinationShift));
          }
          if (before != null) {
            nextInstructionRangesToTest.add(before);
          }
          if (after != null) {
            nextInstructionRangesToTest.add(after);
          }
        }
      }
      nextInstructionsGroupRangesToTest.addAll(nextInstructionRangesToTest);
      nextInstructionRangesToTest.clear();
    }
    return minList(nextInstructionsGroupRangesToTest.map<int>((range) => range.start).toList());
  }
}

class Instruction {
  final int destinationRangeStart;
  final Range sourceRange;
  final int rangeLength;
  final int sourceDestinationShift;

  Instruction({
    required this.destinationRangeStart,
    required this.sourceRange,
    required this.rangeLength,
    required this.sourceDestinationShift,
  });

  factory Instruction.fromLine(String line) {
    final sourceRangeStart = int.parse(line.split(' ')[1]);
    final rangeLength = int.parse(line.split(' ')[2]);
    final destinationRangeStart = int.parse(line.split(' ')[0]);
    return Instruction(
      destinationRangeStart: destinationRangeStart,
      sourceRange: Range(start: sourceRangeStart, end: sourceRangeStart + rangeLength - 1),
      rangeLength: rangeLength,
      sourceDestinationShift: destinationRangeStart - sourceRangeStart,
    );
  }
}

class Range {
  final int start;
  final int end;

  Range({required this.start, required this.end})
      : assert(start <= end, 'Range start must be less than or equal to end but got start:$start and end:$end');

  factory Range.singleValue({required int value}) => Range(start: value, end: value);

  bool hasCommonValues({required Range range}) {
    return (range.start <= this.end && range.end >= this.start);
  }

  Range shift(int shiftValue) {
    return Range(start: this.start + shiftValue, end: this.end + shiftValue);
  }

  (Range? before, Range? inter, Range? after) cutOut({required Range range}) {
    Range? before, inter, after;
    final (interMax, interMin) = (max(this.start, range.start), min(this.end, range.end));
    if (this.start < range.start) {
      if (this.end < range.start) {
        before = Range(start: this.start, end: this.end);
      } else {
        before = Range(start: this.start, end: range.start - 1);
      }
    }
    if (interMax <= interMin) {
      inter = Range(start: interMax, end: interMin);
    }
    if (this.end > range.end) {
      if (this.start > range.end) {
        after = Range(start: this.start, end: this.end);
      } else {
        after = Range(start: range.end + 1, end: this.end);
      }
    }
    return (before, inter, after);
  }

  @override
  String toString() {
    return 'Range(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) =>
      other is Range && other.runtimeType == runtimeType && other.start == start && other.end == end;

  @override
  int get hashCode => start.hashCode + end.hashCode;
}

int minList(List<int> values) {
  int minValue = values[0];
  for (final value in values) {
    minValue = min(minValue, value);
  }
  return minValue;
}

Future<void> main() async {
  final inputText = await getInput(fileName: 'input.txt');
  final gardenPart1 = GardenPlan.fromText(lines: inputText, isPart2: false);
  final gardenPart2 = GardenPlan.fromText(lines: inputText);
  print('Part 1: ${gardenPart1.getMinLocationInGarden()}');
  print('Part 2: ${gardenPart2.getMinLocationInGarden()}');
}
