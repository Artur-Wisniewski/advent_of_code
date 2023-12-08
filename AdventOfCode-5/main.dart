import '../utils.dart';

///--- Day 5: If You Give A Seed A Fertilizer ---

class Info {
  final int destinationRangeStart;
  final int sourceRangeStart;
  final int rangeLength;

  Info({
    required this.destinationRangeStart,
    required this.sourceRangeStart,
    required this.rangeLength,
  });

  factory Info.fromLine(String line) {
    return Info(
      destinationRangeStart: int.parse(line.split(' ')[0]),
      sourceRangeStart: int.parse(line.split(' ')[1]),
      rangeLength: int.parse(line.split(' ')[2]),
    );
  }

  bool isValueInRange(int number) {
    return number >= sourceRangeStart && number <= sourceRangeStart + rangeLength;
  }

  int shiftValue(int number) {
    return number - sourceRangeStart + destinationRangeStart;
  }
}

Future<void> main() async {
  final inputText = await getInput();
  var [firstKey, seedsText] = inputText[0].split(':');
  final List<int> seeds = seedsText.trim().split(' ').map((e) => int.parse(e)).toList();
  final Map<String, List<int>> map = {firstKey: seeds};
  var (currentKey, previousKey) = (firstKey, firstKey);
  for (int i = 2; i < inputText.length; i++) {
    final line = inputText[i];

    bool isMapLine() {
      return line.contains(':');
    }

    void copyLeftValues() {
      map[currentKey]!.addAll(map[previousKey]!);
    }

    bool isLastLine() {
      return i == inputText.length - 1;
    }

    if (isMapLine()) {
      previousKey = currentKey;
      currentKey = line;
      map.addAll({currentKey: []});
    } else if (line.isNotEmpty) {
      final info = Info.fromLine(line);
      final valuesCopy = List.from(map[previousKey]!);
      for (final value in valuesCopy) {
        if (info.isValueInRange(value)) {
          map[previousKey]!.remove(value);
          map[currentKey]!.add(info.shiftValue(value));
        }
      }
      if (isLastLine()) {
        copyLeftValues();
      }
    } else {
      copyLeftValues();
    }
  }
  int minValue = map[currentKey]!.first;
  for (final value in map[currentKey]!) {
    if (value < minValue) minValue = value;
  }
  print(minValue);
}
