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

  int getWinningNumbersCount() => scratchcardNumbers.where((element) => winningNumbers.contains(element)).length;

  int getPointsWorth() {
    final power = getWinningNumbersCount() - 1;
    if (power < 0) return 0;
    return pow(2, power).toInt();
  }
}

List<Scratchcard> getWonScratchcardFromScratchcard(Scratchcard scratchcard, List<Scratchcard> originalScratchCards) {
  final List<Scratchcard> allScratchCards = [];
  allScratchCards.add(scratchcard);
  final winningNumbersCount = scratchcard.getWinningNumbersCount();
  if (winningNumbersCount > 0) {
    for (int j = 1; j < winningNumbersCount + 1; j++) {
      final scratchCardIndex = scratchcard.id - 1 + j;
      if (scratchCardIndex < originalScratchCards.length) {
        final scratchcardCopy = originalScratchCards[scratchCardIndex];
        final scratchCards = getWonScratchcardFromScratchcard(scratchcardCopy, originalScratchCards);
        allScratchCards.addAll(scratchCards);
      }
    }
  }
  return allScratchCards;
}

Future<void> main() async {
  final inputText = await getInput();
  int pointsSum = 0;
  final originalScratchcards = <Scratchcard>[];
  for (final line in inputText) {
    final scratchcard = Scratchcard.fromText(line: line);
    originalScratchcards.add(scratchcard);
    pointsSum += scratchcard.getPointsWorth();
  }
  int sumOfWonScratchcards = 0;
  for (final scratchcard in originalScratchcards) {
    sumOfWonScratchcards += getWonScratchcardFromScratchcard(scratchcard, originalScratchcards).length;
  }

  print('Sum of the points: $pointsSum');
  print('Sum of the won scratchcards: $sumOfWonScratchcards');
}
