import 'dart:io';

final RegExp onlyPositiveNumbersRegExp = RegExp(r'\d+');

Future<List<String>> getInput({String fileName = 'input.txt'}) async {
  return await File(fileName).readAsLines();
}

int greatestCommonDivisor(int a, int b) => a.gcd(b);

int leastCommonMultiple(int a, int b) {
  if ((a == 0) || (b == 0)) {
    return 0;
  }
  return ((a ~/ greatestCommonDivisor(a, b)) * b).abs();
}

int leastCommonMultipleList(List<int> numbers) {
  int answer = 1;
  for (int number in numbers) {
    answer = leastCommonMultiple(answer, number);
  }
  return answer;
}

class Position {
  int x;
  int y;

  Position(this.x, this.y);

  @override
  String toString() {
    return '($x, $y)';
  }
}

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

  Directions get leftMirror {
    return switch (this) {
      Directions.north => Directions.west,
      Directions.south => Directions.east,
      Directions.east => Directions.south,
      Directions.west => Directions.north,
    };
  }

  Directions get rightMirror {
    return switch (this) {
      Directions.north => Directions.east,
      Directions.south => Directions.west,
      Directions.east => Directions.north,
      Directions.west => Directions.south,
    };
  }
}