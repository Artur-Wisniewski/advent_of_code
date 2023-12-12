import '../utils.dart';

class Universe {
  final List<Galaxy> galaxies;
  final List<List<String>> map;
  final bool isExpanded;

  const Universe._(this.galaxies, this.map, this.isExpanded);

  factory Universe.fromInput(List<String> input) {
    List<List<String>> map = [];
    for (String line in input) {
      map.add(line.split(''));
    }
    return Universe._([], map, false);
  }

  void applyCosmicExpansion() {
    assert(!isExpanded, 'Universe is already expanded');
    final List<List<String>> mapCopy = [];
    for (List<String> row in map) {
      mapCopy.add(List<String>.from(row));
    }

    final int startWidth = mapCopy[0].length;
    for (int y = 0; y < mapCopy.length; y++) {
      final rowCopy = List<String>.from(mapCopy[y]);
      if (rowCopy.every((tile) => tile == '.')) {
        final indexToInsert = y + map.length - mapCopy.length;
        map.insert(indexToInsert, List.generate(startWidth, (_) => '.'));
      }
    }
    for (int x = 0; x < startWidth; x++) {
      final columnCopy = mapCopy.map((row) => row[x]).toList();
      if (columnCopy.every((tile) => tile == '.')) {
        for (int y = 0; y < map.length; y++) {
          final int currentWidth = map[y].length;
          final int indexToInsert = x + currentWidth - startWidth;
          map[y].insert(indexToInsert, '.');
        }
      }
    }
  }

  void findGalaxies() {
    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        if (map[y][x] == '#') {
          galaxies.add(Galaxy(Position(x, y)));
        }
      }
    }
  }

  int sumOfShortestDistances() {
    int sum = 0;
    for (int i = 0; i < galaxies.length - 1; i++) {
      for (int j = i + 1; j < galaxies.length; j++) {
        final Galaxy galaxy = galaxies[i];
        final Galaxy otherGalaxy = galaxies[j];
        if (galaxy != otherGalaxy) {
          int distance = galaxy.calculateShortestDistanceTo(galaxy: otherGalaxy);
          sum += distance;
        }
      }
    }
    return sum;
  }

  void printMap() {
    for (List<String> row in map) {
      print(row.join());
    }
  }
}

class Galaxy {
  Position position;

  Galaxy(this.position);

  int calculateShortestDistanceTo({required Galaxy galaxy}) {
    final int xDistance = (position.x - galaxy.position.x).abs();
    final int yDistance = (position.y - galaxy.position.y).abs();
    return xDistance + yDistance;
  }
}

Future<void> main() async {
  List<String> input = await getInput(fileName: 'input.txt');
  Universe universe = Universe.fromInput(input)
    ..applyCosmicExpansion()
    ..findGalaxies();
  //universe.printMap();
  print(universe.sumOfShortestDistances());
}
