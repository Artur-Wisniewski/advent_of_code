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

  bool isVertical() {
    return switch (this) {
      Directions.north => true,
      Directions.south => true,
      Directions.east => false,
      Directions.west => false,
    };
  }

  bool isHorizontal() {
    return switch (this) {
      Directions.north => false,
      Directions.south => false,
      Directions.east => true,
      Directions.west => true,
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

  bool canGoInDirection({required Directions goTo, required List<Directions> sideOnTile}) {
    if (TileTypes.ground == this) return true;
    if (TileTypes.start == this) return false;
    if (this.directionsToConnect.contains(goTo)) return true;
    // Straight lines
    if (this.directionsToConnect[0].opposite == this.directionsToConnect[1]) {
      final perpendicularDirection = sideOnTile
          .firstWhere((element) => (element != this.directionsToConnect[0] && element != this.directionsToConnect[1]));
      if (goTo == perpendicularDirection) return true;
      return false;
    }
    // Corners
    if (sideOnTile.contains(this.directionsToConnect[0]) && sideOnTile.contains(this.directionsToConnect[1])) {
      return sideOnTile.contains(goTo);
    }
    return true;
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
  bool? isInsideLoop;
  bool isChecked = false;

  bool get isInLoop => distanceToStart != null;

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

void markTilesOutsideLoop(List<List<Tile>> tileMatrix) {
  for (int i = 0; i < tileMatrix.first.length; i++) {
    final Tile tile = tileMatrix.first[i];
    markTilesOutsideLoopGroup(
      tileMatrix: tileMatrix,
      tile: tile,
      comeFromDirectionVertical: Directions.north,
      comeFromDirectionHorizontal: i != tileMatrix[0].length - 1 ? Directions.west : Directions.east,
    );
  }
  for (int i = 1; i < tileMatrix.length - 1; i++) {
    markTilesOutsideLoopGroup(
      tileMatrix: tileMatrix,
      tile: tileMatrix[i].first,
      comeFromDirectionVertical: Directions.west,
      comeFromDirectionHorizontal: Directions.north,
    );
    markTilesOutsideLoopGroup(
      tileMatrix: tileMatrix,
      tile: tileMatrix[i].last,
      comeFromDirectionHorizontal: Directions.east,
      comeFromDirectionVertical: Directions.north,
    );
  }
  for (int i = 0; i < tileMatrix.last.length; i++) {
    final Tile tile = tileMatrix.last[i];
    markTilesOutsideLoopGroup(
      tileMatrix: tileMatrix,
      tile: tile,
      comeFromDirectionVertical: Directions.south,
      comeFromDirectionHorizontal: i != tileMatrix[0].length - 1 ? Directions.west : Directions.east,
    );
  }
}

Tile? markTilesOutsideLoopGroup(
    {required List<List<Tile>> tileMatrix,
    required Tile tile,
    required Directions comeFromDirectionVertical,
    required Directions comeFromDirectionHorizontal}) {
  if (tile.isChecked) return null;
  // print(tile.position);
  // printOutMatrix(tileMatrix, printOnly: true);
  tile.isChecked = true;
  if (!tile.isInLoop) {
    tile.isInsideLoop = false;
  }
  for (final directionTarget in Directions.values) {
    Directions nextHorizontalDirection = comeFromDirectionHorizontal;
    Directions nextVerticalDirection = comeFromDirectionVertical;

    if (tile.isInLoop) {
      if (!tile.type.canGoInDirection(
          goTo: directionTarget, sideOnTile: [comeFromDirectionVertical, comeFromDirectionHorizontal])) {
        continue;
      } else {
        bool directionsAreAlongEachOther() {
          return tile.type.directionsToConnect[0] == tile.type.directionsToConnect[1].opposite;
        }

        bool directionsAndComeFromAreTheSame() {
          return tile.type.directionsToConnect.contains(comeFromDirectionHorizontal) &&
              tile.type.directionsToConnect.contains(comeFromDirectionVertical);
        }

        if (!directionsAndComeFromAreTheSame() && !directionsAreAlongEachOther()) {
          nextVerticalDirection = tile.type.directionsToConnect.firstWhere((element) => element.isVertical()).opposite;
          nextHorizontalDirection =
              tile.type.directionsToConnect.firstWhere((element) => element.isHorizontal()).opposite;
        }
      }
    }
    if (directionTarget.isHorizontal()) {
      nextHorizontalDirection = directionTarget.opposite;
    } else if (directionTarget.isVertical()) {
      nextVerticalDirection = directionTarget.opposite;
    }
    final nextTile = tile.getTileAt(direction: directionTarget);
    if (nextTile == null) continue;
    markTilesOutsideLoopGroup(
      tileMatrix: tileMatrix,
      tile: nextTile,
      comeFromDirectionVertical: nextVerticalDirection,
      comeFromDirectionHorizontal: nextHorizontalDirection,
    );
  }
  return null;
}

int countUnMarkedTiles(List<List<Tile>> tileMatrix) {
  int count = 0;
  for (final row in tileMatrix) {
    for (final tile in row) {
      if (tile.isInLoop || tile.isInsideLoop != null) continue;
      tile.isInsideLoop = true;
      count++;
    }
  }
  return count;
}

void printOutMatrix(List<List<Tile>> tileMatrix, {bool printOnly = false}) {
  print('');
  final StringBuffer buffer = StringBuffer();
  for (final row in tileMatrix) {
    for (final tile in row) {
      if (tile.isChecked && tile.isInLoop) {
        buffer.write('%');
      } else if (tile.isInLoop) {
        buffer.write('#');
      } else if (tile.isChecked) {
        buffer.write('X');
      } else {
        buffer.write('.');
      }
    }
    print(buffer);
    buffer.clear();
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
  markTilesOutsideLoop(tileMatrix);
  // printOutMatrix(tileMatrix);
  print(countUnMarkedTiles(tileMatrix));
}
