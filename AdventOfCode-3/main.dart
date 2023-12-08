import '../utils.dart';

class Engine {
  final List<List<String>> _grid;
  final int _width;
  final int _height;
  final List<List<int>> _symbolsNeighboursValues;

  Engine({
    required List<List<String>> grid,
  })
      : _grid = grid,
        _width = grid[0].length,
        _symbolsNeighboursValues = [],
        _height = grid.length {
    init();
  }

  factory Engine.fromText({required List<String> lines}) {
    return Engine(grid: lines.map<List<String>>((String e) => e.split('')).toList());
  }

  void init() {
    _symbolsNeighboursValues.addAll(_setAllNeighboursValues());
  }

  List<List<int>> _setAllNeighboursValues() {
    List<List<int>> neighboursValues = [];
    for (int y = 0; y < _height; y++) {
      for (int x = 0; x < _width; x++) {
        final cell = getCell(x: x, y: y);
        if (_isEngineSymbol(cell)) {
          final neighbours = _getNeighboursValues(x, y);
          neighboursValues.add(neighbours);
        }
      }
    }
    return neighboursValues;
  }

  String getCell({required int x, required int y}) {
    return _grid[y][x];
  }

  int calculateEngineSum() {
    return _symbolsNeighboursValues
        .reduce((List<int> values, List<int> values2) => values..addAll(values2))
        .reduce((value, element) => value + element);
  }

  int calculateGearRatioSum() {
    final List<int> gearRatioValues = [];
    _symbolsNeighboursValues.forEach((element) {
      if (element.length == 2) gearRatioValues.add
        (element[0] * element[1]);
    });
    return gearRatioValues.reduce((value, element) => value + element);
  }

  List<int> _getNeighboursValues(int x, int y) {
    List<int> neighboursValues = [];
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int xShifted = (x + i).clamp(0, _width - 1);
        int yShifted = (y + j).clamp(0, _height - 1);
        if ((i == 0 && j == 0) || x + i > _width || y + 1 > _height) continue;
        String cell = getCell(x: xShifted, y: yShifted);
        if (_isNumber(cell)) {
          // find number start cell
          xShifted = _getNeighbourStartX(firstNumberEncounterX: xShifted, firstNumberEncounterY: yShifted);
          StringBuffer number = StringBuffer();
          for (int k = xShifted; k < _width; k++) {
            cell = getCell(x: k, y: yShifted);
            void saveNumber({required int endX}) {
              neighboursValues.add(int.parse(number.toString()));
              _clearValue(startX: xShifted, endX: endX, y: yShifted);
            }

            if (!_isNumber(getCell(x: k, y: yShifted))) {
              saveNumber(endX: k - 1);
              break;
            }
            number.write(cell);
            if (k == _width - 1) {
              saveNumber(endX: k);
            }
          }
        }
      }
    }
    return neighboursValues;
  }

  int _getNeighbourStartX({required int firstNumberEncounterX, required int firstNumberEncounterY}) {
    int startX = firstNumberEncounterX;
    for (; startX >= 0; startX--) {
      final cell = getCell(x: startX, y: firstNumberEncounterY);
      if (!_isNumber(cell)) {
        break;
      }
    }
    startX++;
    return startX;
  }

  void _setCell({required int x, required int y, required String value}) {
    _grid[y][x] = value;
  }

  void _clearValue({required int startX, required int endX, required int y}) {
    for (int x = startX; x <= endX; x++) {
      _setCell(x: x, y: y, value: '.');
    }
  }

  // Check if symbol is not a number or a dot
  bool _isEngineSymbol(String cell) => cell.contains(RegExp(r'[^.\d]'));

  bool _isNumber(String cell) => cell.contains(RegExp(r'\d'));
}

Future<void> main() async {
  final input = await getInput();
  final Engine engine = Engine.fromText(lines: input);

  print('Gear ratio sum:  ${engine.calculateGearRatioSum()}');
  print('Gear engine sum: ${engine.calculateEngineSum()}');
}
