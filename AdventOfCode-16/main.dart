import '../adventOfCode-10/main.dart';
import '../utils.dart';

enum FieldTypes {
  empty,
  horizontalSplitter,
  verticalSplitter,
  rightMirror,
  leftMirror;

  static FieldTypes fromString(String fieldType) {
    switch (fieldType) {
      case HORIZONTAL_SPLITTER:
        return FieldTypes.horizontalSplitter;
      case VERTICAL_SPLITTER:
        return FieldTypes.verticalSplitter;
      case RIGHT_MIRROR:
        return FieldTypes.rightMirror;
      case LEFT_MIRROR:
        return FieldTypes.leftMirror;
      case EMPTY_FIELD:
        return FieldTypes.empty;
      default:
        throw Exception('Unknown field type');
    }
  }
}

const String HORIZONTAL_SPLITTER = '-';
const String VERTICAL_SPLITTER = '|';
const String RIGHT_MIRROR = '/';
const String LEFT_MIRROR = '\\';
const String ENERGIZED_FIELD = '#';
const String EMPTY_FIELD = '.';
// cache beam for no repetitions

class Beam {
  final int x;
  final int y;
  final Directions direction;

  Beam(this.x, this.y, this.direction);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Beam && runtimeType == other.runtimeType && x == other.x && y == other.y && direction == other.direction;
}

final List<Beam> seenBeams = [];

void markEnergizedFields(List<List<String>> energizedFields, List<List<String>> inputRecords, Beam beam) {
  if (beam.x < 0 || beam.x >= inputRecords[0].length || beam.y < 0 || beam.y >= inputRecords.length) {
    return;
  }

  if (seenBeams.contains(beam)) {
    return;
  }
  seenBeams.add(beam);

  energizedFields[beam.y][beam.x] = ENERGIZED_FIELD;

  FieldTypes fieldType = FieldTypes.fromString(inputRecords[beam.y][beam.x]);
  switch (fieldType) {
    case FieldTypes.empty:
      final newBeam = Beam(beam.x + beam.direction.offsetX, beam.y + beam.direction.offsetY, beam.direction);
      markEnergizedFields(energizedFields, inputRecords, newBeam);
      break;
    case FieldTypes.horizontalSplitter:
      if (beam.direction == Directions.east || beam.direction == Directions.west) {
        final newBeam = Beam(beam.x + beam.direction.offsetX, beam.y + beam.direction.offsetY, beam.direction);
        markEnergizedFields(energizedFields, inputRecords, newBeam);
      } else {
        final newBeam1 = Beam(beam.x + Directions.west.offsetX, beam.y + Directions.west.offsetY, Directions.west);
        final newBeam2 = Beam(beam.x + Directions.east.offsetX, beam.y + Directions.east.offsetY, Directions.east);
        markEnergizedFields(energizedFields, inputRecords, newBeam1);
        markEnergizedFields(energizedFields, inputRecords, newBeam2);
      }
      break;
    case FieldTypes.verticalSplitter:
      if (beam.direction == Directions.north || beam.direction == Directions.south) {
        final newBeam = Beam(beam.x + beam.direction.offsetX, beam.y + beam.direction.offsetY, beam.direction);
        markEnergizedFields(energizedFields, inputRecords, newBeam);
      } else {
        final newBeam1 = Beam(beam.x + Directions.north.offsetX, beam.y + Directions.north.offsetY, Directions.north);
        final newBeam2 = Beam(beam.x + Directions.south.offsetX, beam.y + Directions.south.offsetY, Directions.south);
        markEnergizedFields(energizedFields, inputRecords, newBeam1);
        markEnergizedFields(energizedFields, inputRecords, newBeam2);
      }
      break;
    case FieldTypes.rightMirror:
      final newDirection = beam.direction.rightMirror;
      final newBeam = Beam(beam.x + newDirection.offsetX, beam.y + newDirection.offsetY, newDirection);
      markEnergizedFields(energizedFields, inputRecords, newBeam);
      break;
    case FieldTypes.leftMirror:
      final newDirection = beam.direction.leftMirror;
      final newBeam = Beam(beam.x + newDirection.offsetX, beam.y + newDirection.offsetY, newDirection);
      markEnergizedFields(energizedFields, inputRecords, newBeam);
      break;
  }
}

void printEnergizedFields(List<List<String>> energizedFields, List<List<String>> inputRecords) {
  final StringBuffer sb = StringBuffer();
  for (int i = 0; i < energizedFields.length; i++) {
    for (int j = 0; j < energizedFields[i].length; j++) {
      if (energizedFields[i][j] == ENERGIZED_FIELD) {
        sb.write(energizedFields[i][j]);
      } else {
        sb.write(inputRecords[i][j]);
      }
    }
    sb.writeln();
  }
  print(sb.toString());
}

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');
  final List<List<String>> inputRecords = input.map((e) => e.split('')).toList();
  final List<List<String>> energizedFields =
      List.generate(inputRecords.length, (_) => List<String>.generate(inputRecords[0].length, (_) => '.'));
  markEnergizedFields(energizedFields, inputRecords, Beam(0, 0, Directions.east));
  int count = 0;
  for (List<String> row in energizedFields) {
    for (String field in row) {
      if (field == '#') {
        count++;
      }
    }
  }
  print('Number of energizedFields: $count');
}
