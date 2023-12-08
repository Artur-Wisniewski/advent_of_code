import '../utils.dart';

/// --- Day 2: Cube Conundrum ---

class Game {
  final int id;
  List<GameSet> set;

  Game(this.id, this.set);

  factory Game.fromText({required String line}) {
    final gameConfig = line.split(':');
    final gameId = int.parse(gameConfig[0].split(' ')[1]);
    final gameSets = gameConfig[1].split(';').map((String line) => GameSet.fromText(line: line)).toList();
    return (Game(gameId, gameSets));
  }

  bool isGamePossible() {
    for (final gameSet in set) {
      if (!gameSet.isSetPossible()) return false;
    }
    return true;
  }

  int calculatePower(){
    int redCubesMin = 0;
    int greenCubesMin = 0;
    int blueCubesMin = 0;
    for (final gameSet in set) {
      if(redCubesMin < gameSet.redCubesSum) redCubesMin = gameSet.redCubesSum;
      if(greenCubesMin < gameSet.greenCubesSum) greenCubesMin = gameSet.greenCubesSum;
      if(blueCubesMin < gameSet.blueCubesSum) blueCubesMin = gameSet.blueCubesSum;
    }
    return redCubesMin * greenCubesMin * blueCubesMin;
  }
}

class GameSet {
  static const maxRedCubes = 12;
  static const maxGreenCubes = 13;
  static const maxBlueCubes = 14;

  final int redCubesSum;
  final int greenCubesSum;
  final int blueCubesSum;

  GameSet({
    required this.redCubesSum,
    required this.greenCubesSum,
    required this.blueCubesSum,
  });

  factory GameSet.fromText({required String line}) {
    final cubes = line.split(', ');
    int redCubesSum = 0;
    int greenCubesSum = 0;
    int blueCubesSum = 0;
    for (final cube in cubes) {
      final cubeColor = cube.trim().split(' ');
      final cubeCount = int.parse(cubeColor[0]);
      final cubeColorName = cubeColor[1];
      switch (cubeColorName) {
        case 'red':
          redCubesSum += cubeCount;
          break;
        case 'green':
          greenCubesSum += cubeCount;
          break;
        case 'blue':
          blueCubesSum += cubeCount;
          break;
      }
    }

    return GameSet(
      redCubesSum: redCubesSum,
      greenCubesSum: greenCubesSum,
      blueCubesSum: blueCubesSum,
    );
  }

  bool isSetPossible() {
    return redCubesSum <= maxRedCubes && greenCubesSum <= maxGreenCubes && blueCubesSum <= maxBlueCubes;
  }
}

Future<void> main() async {
  final input = await getInput();
  int powerSum = 0;
  int idsSum = 0;
  for (var line in input) {
    final game = Game.fromText(line: line);
    if (game.isGamePossible()) {
      idsSum += game.id;
    }
    powerSum += game.calculatePower();
  }
  print('Sum of the IDs of the games that would have been possible: $idsSum');
  print('Sum of the power of the games: $powerSum');
}
