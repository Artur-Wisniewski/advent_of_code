import '../utils.dart';

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');

  final List<String> sequencesToHash = input[0].split(',').toList();
  int sum = 0;
  for (final sequence in sequencesToHash) {
    int hash = 0;
    final sequenceValues = sequence.runes;
    for (final rune in sequenceValues) {
      hash += rune;
      hash *= 17;
      hash = hash % 256;
    }
    print(hash);
    sum += hash;
  }
  print(sum);
}
