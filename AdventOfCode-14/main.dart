import '../utils.dart';

enum Symbol {
  BOULDER('#'),
  ROUND_BOULDER('O'),
  EMPTY_SPACE('.');

  final String text;

  bool get isBoulder => this == BOULDER;

  bool get isRoundBoulder => this == ROUND_BOULDER;

  bool get isEmptySpace => this == EMPTY_SPACE;

  const Symbol(this.text);

  factory Symbol.fromText(String text) => switch (text) {
        '#' => Symbol.BOULDER,
        'O' => Symbol.ROUND_BOULDER,
        '.' => Symbol.EMPTY_SPACE,
        _ => throw Exception('Unknown symbol: $text'),
      };
}

int countLoad(List<List<Symbol>> map, {bool printMap = false}) {
  StringBuffer buffer = StringBuffer();
  int sum = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      buffer.write(map[i][j].text);
      final symbol = map[i][j];
      if (symbol.isRoundBoulder) {
        sum += map.length - i;
      }
    }
    buffer.writeln();
  }
  if (printMap) {
    print(buffer.toString());
  }
  return sum;
}

List<List<Symbol>> applyNorthTilt(List<List<Symbol>> map) {
  for (int x = 0; x < map[0].length; x++) {
    for (int y = 0; y < map.length; y++) {
      final currentSymbol = map[y][x];
      if (!currentSymbol.isRoundBoulder) {
        continue;
      } else {
        for (int i = y - 1; i >= 0; i--) {
          final symbol = map[i][x];
          if (symbol.isBoulder || symbol.isRoundBoulder) {
            map[y][x] = Symbol.EMPTY_SPACE;
            map[i + 1][x] = Symbol.ROUND_BOULDER;
            break;
          }
          if (symbol.isEmptySpace && i == 0) {
            map[y][x] = Symbol.EMPTY_SPACE;
            map[i][x] = Symbol.ROUND_BOULDER;
          }
        }
      }
    }
  }
  return map;
}

List<List<Symbol>> rotate(List<List<Symbol>> map) {
  final List<List<Symbol>> newMap = [];
  for (int y = 0; y < map.length; y++) {
    for (int x = 0; x < map[y].length; x++) {
      if (x == 0) {
        newMap.add([]);
      }
      newMap[y].add(map[map.length - 1 - x][y]);
    }
  }
  return newMap;
}

final Map<String, List<List<Symbol>>> cache = {};

(List<List<Symbol>>, int? cacheCycleCount) applySpin(List<List<Symbol>> inputMap) {
  List<List<Symbol>> map = inputMap;
  final key = getKeys(map);
  if (cache.containsKey(key)) {
    return (cache[key]!, cache.length);
  }
  for (int i = 0; i < 4; i++) {
    map = applyNorthTilt(inputMap);
    map = rotate(map);
  }

  cache.addAll({key: copyList(map)});
  return (map, null);
}

List<List<Symbol>> copyList(List<List<Symbol>> map) {
  final List<List<Symbol>> newMap = [];
  for (int i = 0; i < map.length; i++) {
    newMap.add([]);
    for (int j = 0; j < map[i].length; j++) {
      newMap[i].add(map[i][j]);
    }
  }
  return newMap;
}

String getKeys(List<List<Symbol>> map) {
  StringBuffer key = StringBuffer();
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j].isRoundBoulder) {
        key.write((1 << j).toRadixString(32));
      }
    }
  }
  return key.toString();
}

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');
  List<List<Symbol>> map = [];
  for (final line in input) {
    map.add(line.split('').map((e) => Symbol.fromText(e)).toList());
  }

  int? cacheCycleCountR;
  bool checkingSequence = false;
  int sequenceCheckingIndex = 0;
  int checkingSequenceLength = 0;
  int sequenceLength = 0;
  List<int> numbers = [];
  for (int i = 0; i < 1000000000; i++) {
    var (newMap, cacheCycleCount) = applySpin(map);
    cacheCycleCountR = cacheCycleCount;
    map = newMap;
    if (cacheCycleCount != null) {
      int value = countLoad(map);
      if (numbers.isNotEmpty) {
        if (!checkingSequence) {
          if (numbers.first == value) {
            checkingSequence = true;
            sequenceCheckingIndex = 1;
            checkingSequenceLength = numbers.length;
          }
        } else {
          if (numbers[sequenceCheckingIndex] == value) {
            sequenceCheckingIndex++;
            if (sequenceCheckingIndex == checkingSequenceLength) {
              sequenceLength = checkingSequenceLength;
              break;
            }
          } else {
            checkingSequence = false;
            sequenceCheckingIndex = 0;
          }
        }
      }
      numbers.add(value);
    }
  }
  print(sequenceLength);
  print(cacheCycleCountR);
  print('Part2: result');
  print(numbers[(1000000000 - cacheCycleCountR! - 1) % sequenceLength]);
}
