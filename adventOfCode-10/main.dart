import '../utils.dart';

enum Directions {
  north._(0, -1),
  south._(0, 1),
  east._(1, 0),
  west._(-1, 0);

  const Directions._(this.offsetX, this.offsetY);

  final int offsetX;
  final int offsetY;

  Directions get opposite {
    return switch (this) {
      Directions.north => Directions.south,
      Directions.south => Directions.north,
      Directions.east => Directions.west,
      Directions.west => Directions.east,
    };
  }
}

enum TileTypes {
  start._('S', [Directions.east, Directions.west, Directions.north, Directions.south]),
  vertical._('|', [Directions.north, Directions.south]),
  horizontal._('-', [Directions.east, Directions.west]),
  northEast._('L', [Directions.north, Directions.east]),
  northWest._('J', [Directions.north, Directions.west]),
  southWest._('7', [Directions.south, Directions.west]),
  southEast._('F', [Directions.south, Directions.east]),
  ground._('.', []);

  const TileTypes._(this.symbol, this.directionsToConnect);

  factory TileTypes.fromSymbol(String symbol) {
    return switch (symbol) {
      'S' => TileTypes.start,
      '|' => TileTypes.vertical,
      '-' => TileTypes.horizontal,
      'L' => TileTypes.northEast,
      'J' => TileTypes.northWest,
      '7' => TileTypes.southWest,
      'F' => TileTypes.southEast,
      '.' => TileTypes.ground,
      _ => throw Exception('Unknown symbol: $symbol'),
    };
  }

  final String symbol;

  final List<Directions> directionsToConnect;
}

class Tile {
  final TileTypes type;
  final Position position;
  int? distanceToStart;
  final List<List<Tile>> tileMatrix;
  Directions? directionToStart;

  Tile(this.type, this.position, this.tileMatrix, {this.distanceToStart});

  Tile? getTileAt({required Directions direction}) {
    if (position.y + direction.offsetY < 0 || position.y + direction.offsetY >= tileMatrix.length) {
      return null;
    }
    if (position.x + direction.offsetX < 0 ||
        position.x + direction.offsetX >= tileMatrix[position.y + direction.offsetY].length) {
      return null;
    }
    return tileMatrix[position.y + direction.offsetY][position.x + direction.offsetX];
  }

  List<Tile> findNextTilesForStart() {
    assert(type == TileTypes.start);
    final List<Tile> nextTiles = [];
    for (final direction in Directions.values) {
      final Tile? nextTile = getTileAt(direction: direction);
      if (nextTile != null && nextTile.type.directionsToConnect.contains(direction.opposite)) {
        nextTile.directionToStart = direction.opposite;
        nextTiles.add(nextTile);
      }
    }
    return nextTiles;
  }

  Directions getNextDirection() {
    return type.directionsToConnect.firstWhere((element) => element != directionToStart);
  }

  Tile? findNextTileFrom() {
    assert(type != TileTypes.start);
    if (type == TileTypes.ground || type.directionsToConnect.isEmpty) {
      return null;
    }
    final Directions nextDirection = getNextDirection();
    final Tile? nextTile = getTileAt(direction: nextDirection);
    nextTile?.directionToStart = nextDirection.opposite;
    return nextTile;
  }
}

Future<void> main() async {
  final inputLines = await getInput(fileName: 'input.txt');
  final List<List<String>> inputMatrix = inputLines.map((e) => e.split('')).toList();
  final List<List<Tile>> tileMatrix = [];
  Tile? startTile;
  for (int i = 0; i < inputMatrix.length; i++) {
    tileMatrix.add([]);
    for (int j = 0; j < inputMatrix[i].length; j++) {
      final TileTypes tileType = TileTypes.fromSymbol(inputMatrix[i][j]);
      final Position position = Position(j, i);
      final Tile tile = Tile(tileType, position, tileMatrix);
      if (tileType == TileTypes.start) {
        startTile = tile;
        startTile.distanceToStart = 0;
      }
      tileMatrix[i].add(tile);
    }
  }
  if (startTile == null) {
    throw Exception('Start tile not found');
  }

  List<Tile> tiles = startTile.findNextTilesForStart();
  tiles.forEach((element) {
    element.distanceToStart = 1;
  });
  List<Tile> nextTiles = [];
  int maxDistance = 0;
  bool distanceIncreased = true;
  while (distanceIncreased) {
    for (final tile in tiles) {
      final nextTile = tile.findNextTileFrom();
      if (nextTile != null &&
          (nextTile.distanceToStart == null || nextTile.distanceToStart! > tile.distanceToStart! + 1)) {
        nextTile.distanceToStart = tile.distanceToStart! + 1;
        nextTiles.add(nextTile);
        if (nextTile.distanceToStart! > maxDistance) {
          maxDistance = nextTile.distanceToStart!;
        }
      }
    }
    if (nextTiles.isEmpty) {
      distanceIncreased = false;
    }
    tiles = List.from(nextTiles);
    nextTiles.clear();
  }
  print(maxDistance);
}
