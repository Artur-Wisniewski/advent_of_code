import '../utils.dart';

class Universe {
  final List<Galaxy> galaxies;
  final List<List<String>> map;
  bool isCosmicSpacesInitialised;
  final List<int> xCosmicSpaces = [];
  final List<int> yCosmicSpaces = [];

  Universe._(this.galaxies, this.map, this.isCosmicSpacesInitialised);

  factory Universe.fromInput(List<String> input) {
    List<List<String>> map = [];
    for (String line in input) {
      map.add(line.split(''));
    }
    return Universe._([], map, false);
  }

  void findCosmicSpaces() {
    assert(!isCosmicSpacesInitialised, 'Universe is already expanded');
    isCosmicSpacesInitialised = true;
    for (int y = 0; y < map.length; y++) {
      final row = map[y];
      if (row.every((tile) => tile == '.')) {
        yCosmicSpaces.add(y);
      }
    }
    final width = map[0].length;
    for (int x = 0; x < width; x++) {
      final column = map.map((row) => row[x]).toList();
      if (column.every((tile) => tile == '.')) {
        xCosmicSpaces.add(x);
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

  int sumOfShortestDistances({int cosmicSpaceDistance = 1}) {
    assert(isCosmicSpacesInitialised, 'Cosmic spaces are not initialised');

    int sum = 0;
    for (int i = 0; i < galaxies.length - 1; i++) {
      for (int j = i + 1; j < galaxies.length; j++) {
        final Galaxy galaxy = galaxies[i];
        final Galaxy otherGalaxy = galaxies[j];
        if (galaxy != otherGalaxy) {
          int distance = galaxy.calculateShortestDistanceTo(
            other: otherGalaxy,
            xCosmicSpaces: xCosmicSpaces,
            yCosmicSpaces: yCosmicSpaces,
            cosmicSpaceDistance: cosmicSpaceDistance,
          );
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

  int calculateShortestDistanceTo({
    required Galaxy other,
    required List<int> xCosmicSpaces,
    required List<int> yCosmicSpaces,
    required int cosmicSpaceDistance,
  }) {
    final int xDistance = (position.x - other.position.x).abs() +
        countVerticalCosmicSpacesBetween(other: other, yCosmicSpaces: yCosmicSpaces) * (cosmicSpaceDistance - 1);
    final int yDistance = (position.y - other.position.y).abs() +
        countHorizontalCosmicSpacesBetween(other: other, xCosmicSpaces: xCosmicSpaces) * (cosmicSpaceDistance - 1);
    return xDistance + yDistance;
  }

  int countVerticalCosmicSpacesBetween({
    required Galaxy other,
    required List<int> yCosmicSpaces,
  }) {
    int count = 0;
    for (int yCosmicSpace in yCosmicSpaces) {
      if (position.y > other.position.y) {
        if (yCosmicSpace > other.position.y && yCosmicSpace < position.y) {
          count++;
        }
      } else {
        if (yCosmicSpace > position.y && yCosmicSpace < other.position.y) {
          count++;
        }
      }
    }
    return count;
  }

  int countHorizontalCosmicSpacesBetween({
    required Galaxy other,
    required List<int> xCosmicSpaces,
  }) {
    int count = 0;
    for (int xCosmicSpace in xCosmicSpaces) {
      if (position.x > other.position.x) {
        if (xCosmicSpace > other.position.x && xCosmicSpace < position.x) {
          count++;
        }
      } else {
        if (xCosmicSpace > position.x && xCosmicSpace < other.position.x) {
          count++;
        }
      }
    }
    return count;
  }
}

Future<void> main() async {
  List<String> input = await getInput(fileName: 'input.txt');
  Universe universe = Universe.fromInput(input)
    ..findCosmicSpaces()
    ..findGalaxies();
  print(universe.sumOfShortestDistances(cosmicSpaceDistance: 1000000));
}
