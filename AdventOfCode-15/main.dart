import '../utils.dart';

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');

  final List<String> sequencesToHash = input[0].split(',').toList();

  int equalSing = '='.runes.first;
  int dashSing = '-'.runes.first;
  List<List<(String, int)>> boxes =
      List.generate(256, (_) => List<(String, int)>.empty(growable: true), growable: false);

  for (final isPart2 in [false, true]) {
    int sum = 0;
    String label = '';
    for (final sequence in sequencesToHash) {
      if (isPart2) {
        if (sequence.contains('='))
          label = sequence.split('=')[0];
        else if (sequence.contains('-')) label = sequence.split('-')[0];
      }

      int hash = 0;
      final sequenceValues = sequence.runes;
      bool operation = false;
      int focalLength = 0;
      int operationalSign = 0;
      for (final rune in sequenceValues) {
        if (isPart2) {
          if (operation) {
            focalLength = rune - 48;
            operation = false;
            break;
          }
          if (rune == equalSing || rune == dashSing) {
            operationalSign = rune;
            operation = true;
            continue;
          }
        }
        hash += rune;
        hash *= 17;
        hash = hash % 256;
      }
      sum += hash;
      if (isPart2) {
        final lensWithSameLabelInBoxIndex = boxes[hash].indexWhere((configuration) => configuration.$1 == label);
        if (operationalSign == equalSing) {
          final lens = (label, focalLength);
          if (lensWithSameLabelInBoxIndex != -1) {
            boxes[hash].removeAt(lensWithSameLabelInBoxIndex);
            boxes[hash].insert(lensWithSameLabelInBoxIndex, lens);
          } else {
            boxes[hash].add(lens);
          }
        } else if (operationalSign == dashSing) {
          if (lensWithSameLabelInBoxIndex != -1) {
            boxes[hash].removeAt(lensWithSameLabelInBoxIndex);
          }
        }
      }
    }
    if (isPart2) {
      sum = 0;
      for (int j = 0; j < boxes.length; j++) {
        final box = boxes[j];
        for (int i = 0; i < box.length; i++) {
          final lensFocalLength = box[i].$2;
          sum += (j + 1) * lensFocalLength * (i + 1);
        }
      }
    }

    print('${isPart2 ? 'Part2' : 'Part1'}');
    print(sum);
  }

  /// If the operation character is a dash (-), go to the relevant box and remove
  /// the lens with the given label if it is present in the box. Then, move any remaining lenses
  /// as far forward in the box as they can go without changing their order,
  /// filling any space made by removing the indicated lens.
  /// (If no lens in that box has the given label, nothing happens.)
}
