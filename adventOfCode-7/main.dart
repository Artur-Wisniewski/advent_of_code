import '../utils.dart';

const List<String> cardsSymbols = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'];

class CamelHand implements Comparable<CamelHand> {
  final List<String> cards;
  final int bid;
  int rank = 0;

  CamelHand({required this.cards, required this.bid});

  int getScore() {
    return bid * rank;
  }

  int _getHandTypeValue() {
    final Map<String, int> cardsCounts = {};
    for (final card in cards) {
      cardsCounts.putIfAbsent(card, () => 0);
      cardsCounts[card] = (cardsCounts[card] ?? 0) + 1;
    }
    bool isFiveOfAKind() => cardsCounts.length == 1;
    bool isFourOfAKind() => cardsCounts.values.contains(4);
    bool isFullHouse() => cardsCounts.values.contains(3) && cardsCounts.values.contains(2);
    bool isThreeOfAKind() => cardsCounts.values.contains(3) && !cardsCounts.values.contains(2);
    bool isTwoPairs() => cardsCounts.values.where((element) => element == 2).length == 2;
    bool isOnePair() => cardsCounts.values.contains(2);
    bool isHighCard() => cardsCounts.length == 5;

    if (isFiveOfAKind()) {
      return 7;
    } else if (isFourOfAKind()) {
      return 6;
    } else if (isFullHouse()) {
      return 5;
    } else if (isThreeOfAKind()) {
      return 4;
    } else if (isTwoPairs()) {
      return 3;
    } else if (isOnePair()) {
      return 2;
    } else if (isHighCard()) {
      return 1;
    } else {
      throw Exception('Unknown hand type');
    }
  }

  /// Compares this object to another object.
  ///
  /// Returns a value like a [Comparator] when comparing `this` to [other].
  /// That is, it returns a negative integer if `this` is ordered before [other],
  /// a positive integer if `this` is ordered after [other],
  /// and zero if `this` and [other] are ordered together.
  ///
  /// The [other] argument must be a value that is comparable to this object.
  @override
  int compareTo(CamelHand other) {
    final int handTypeValue = _getHandTypeValue();
    final int otherHandTypeValue = other._getHandTypeValue();
    if (handTypeValue == otherHandTypeValue) {
      for (int i = 0; i < other.cards.length; i++) {
        final int cardIndex = cardsSymbols.indexOf(cards[i]);
        final int otherCardIndex = cardsSymbols.indexOf(other.cards[i]);
        if (cardIndex == otherCardIndex) {
          continue;
        }
        return otherCardIndex - cardIndex ;
      }
      return 0;
    }
    return handTypeValue - otherHandTypeValue;
  }

  @override
  String toString() {
    return 'CamelHand{cards: $cards, bid: $bid, rank: $rank}';
  }
}

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');
  final List<CamelHand> hands = [];
  for (final line in input) {
    final [cards, bid] = line.split(' ');
    hands.add(CamelHand(cards: cards.split(''), bid: int.parse(bid)));
  }
  hands.sort();
  int scoreSum = 0;
  for (final hand in hands) {
    hand.rank = hands.indexOf(hand) + 1;
    scoreSum += hand.getScore();
  }
  print(scoreSum);
}
