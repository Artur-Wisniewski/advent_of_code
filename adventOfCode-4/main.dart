import '../utils.dart';
import 'dart:math';

/// --- Day 4: Scratchcards  ---

class Scratchcard {
  final List<int> winningNumbers;
  final List<int> scratchcardNumbers;
  final int id;

  Scratchcard({
    required this.id,
    required this.winningNumbers,
    required this.scratchcardNumbers,
  });

  factory Scratchcard.fromText({required String line}) {
    final scratchcardConfig = line.split(':');
    final id = int.parse(RegExp(r'\S+$').allMatches(scratchcardConfig[0]).map((e) => e.group(0)).first!);
    final numbers = scratchcardConfig[1].split('|');
    final winningNumbers =
        onlyNumbersRegExp.allMatches(numbers[0]).map((e) => e.group(0)).map<int>((e) => int.parse(e!)).toList();
    final scratchcardNumbers =
        onlyNumbersRegExp.allMatches(numbers[1]).map((e) => e.group(0)).map<int>((e) => int.parse(e!)).toList();
    return Scratchcard(id: id, winningNumbers: winningNumbers, scratchcardNumbers: scratchcardNumbers);
  }

  int getPointsWorth() {
    final power = scratchcardNumbers.where((element) => winningNumbers.contains(element)).length - 1;
    if (power < 0) return 0;
    return pow(2, power).toInt();
  }
}

Future<void> main() async {
  final inputText = await getInput();
  int pointsSum = 0;
  for (final line in inputText) {
    final scratchcard = Scratchcard.fromText(line: line);
    pointsSum += scratchcard.getPointsWorth();
  }
  print('Sum of the points: $pointsSum');
}
