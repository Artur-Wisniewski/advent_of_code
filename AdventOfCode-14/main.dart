import '../utils.dart';

const BOULDER = '#';
const ROUND_BOULDER = 'O';
const EMPTY_SPACE = '.';

int countLoad(List<List<String>> map) {
  StringBuffer buffer = StringBuffer();
  int sum = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      buffer.write(map[i][j]);
      final symbol = map[i][j];
      if (symbol == ROUND_BOULDER) {
        sum += map.length - i;
      }
    }
    buffer.writeln();
  }
  print(buffer.toString());
  return sum;
}

void applyNorthTilt(List<List<String>> map) {
  for (int x = 0; x < map[0].length; x++) {
    for (int y = 0; y < map.length; y++) {
      final currentSymbol = map[y][x];
      if (currentSymbol == EMPTY_SPACE || currentSymbol == BOULDER) {
        continue;
      } else {
        for (int i = y - 1; i >= 0; i--) {
          final symbol = map[i][x];
          if (symbol == BOULDER || symbol == ROUND_BOULDER) {
            map[y][x] = EMPTY_SPACE;
            map[i + 1][x] = ROUND_BOULDER;
            break;
          }
          if(symbol == EMPTY_SPACE && i == 0){
            map[y][x] = EMPTY_SPACE;
            map[i][x] = ROUND_BOULDER;
          }
        }
      }
    }
  }
}

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');
  final List<List<String>> map = [];
  for (final line in input) {
    map.add(line.split(''));
  }
  applyNorthTilt(map);
  print(countLoad(map));
}
