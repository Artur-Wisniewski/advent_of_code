import '../utils.dart';

const List<String> cardsSymbols = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'];

enum HandType {
  fiveOfAKind._internal(value: 7),
  fourOfAKind._internal(value: 6),
  fullHouse._internal(value: 5),
  threeOfAKind._internal(value: 4),
  twoPairs._internal(value: 3),
  onePair._internal(value: 2),
  highCard._internal(value: 1);

  final int value;

  const HandType._internal({required this.value});
}

class CamelHand implements Comparable<CamelHand> {
  final List<String> _cards;
  final int bid;
  int rank = 0;
  final int index;

  CamelHand({required List<String> cards, required this.bid, required this.index}) : _cards = cards;

  List<String> get cards => _cards;

  int getScore() {
    return bid * rank;
  }

  Map<String, int> getCardsCounts() {
    final Map<String, int> cardsCounts = {};
    for (final card in cards) {
      cardsCounts.putIfAbsent(card, () => 0);
      cardsCounts[card] = (cardsCounts[card] ?? 0) + 1;
    }
    return cardsCounts;
  }

  HandType getHandType() {
    final Map<String, int> cardsCounts = getCardsCounts();
    bool isFiveOfAKind() => cardsCounts.length == 1;
    bool isFourOfAKind() => cardsCounts.values.contains(4);
    bool isFullHouse() => cardsCounts.values.contains(3) && cardsCounts.values.contains(2);
    bool isThreeOfAKind() => cardsCounts.values.contains(3) && !cardsCounts.values.contains(2);
    bool isTwoPairs() => cardsCounts.values.where((element) => element == 2).length == 2;
    bool isOnePair() => cardsCounts.values.contains(2);
    bool isHighCard() => cardsCounts.length == 5;

    if (isFiveOfAKind()) return HandType.fiveOfAKind;
    if (isFourOfAKind()) return HandType.fourOfAKind;
    if (isFullHouse()) return HandType.fullHouse;
    if (isThreeOfAKind()) return HandType.threeOfAKind;
    if (isTwoPairs()) return HandType.twoPairs;
    if (isOnePair()) return HandType.onePair;
    if (isHighCard()) return HandType.highCard;
    throw Exception('Unknown hand type');
  }

  int getCardValue(String cardSymbol) {
    return cardsSymbols.indexOf(cardSymbol);
  }

  @override
  int compareTo(CamelHand other) {
    final int handTypeValue = getHandType().value;
    final int otherHandTypeValue = other.getHandType().value;
    if (handTypeValue == otherHandTypeValue) {
      for (int i = 0; i < other._cards.length; i++) {
        int cardValue = getCardValue(_cards[i]);
        int otherCardValue = getCardValue(other._cards[i]);
        if (cardValue == otherCardValue) {
          continue;
        }
        return otherCardValue - cardValue;
      }
      return other.index - index;
    }
    return handTypeValue - otherHandTypeValue;
  }

  @override
  String toString() {
    return 'CamelHand{cards: $cards, bid: $bid, rank: $rank}';
  }
}

const String jokerSymbol = 'J';

class CamelHandJokerable extends CamelHand {
  final List<String> _updatedCards;

  CamelHandJokerable({required super.cards, required super.bid, required super.index}): _updatedCards = [...cards];

  @override
  List<String> get cards => _updatedCards;

  @override
  int getCardValue(String cardSymbol) {
    if(cardSymbol == jokerSymbol){
      return cardsSymbols.length;
    }
    return cardsSymbols.indexOf(cardSymbol);
  }

  void generateUpdatedCardsWithWildcards() {
    final Map<String, int> cardsCounts = super.getCardsCounts();
    final int jokersCount = _cards.where((element) => element == jokerSymbol).length;

    if (jokersCount == 0) {
      return;
    }

    int maxValue = 0;
    String minSymbol = '2';
    for (int i = 0; i < cardsCounts.keys.length; i++) {
      final String cardSymbol = cardsCounts.keys.elementAt(i);
      final int cardCount = cardsCounts[cardSymbol] ?? 0;
      if ((cardSymbol != jokerSymbol) && (cardCount > maxValue || (cardCount == maxValue && getCardValue(cardSymbol) < getCardValue(minSymbol)))) {
        maxValue = cardCount;
        minSymbol = cardSymbol;
      }
    }

    _updatedCards.clear();
    for (final card in _cards) {
      if (card == jokerSymbol) {
        _updatedCards.add(minSymbol);
      } else {
        _updatedCards.add(card);
      }
    }
  }

  @override
  HandType getHandType() {
    return super.getHandType();
  }

    @override
  String toString() {
    return 'CamelHandWithJokers{cards: $cards, bid: $bid, rank: $rank}';
  }
}

Future<void> main() async {
  final input = await getInput(fileName: 'input.txt');
  final List<CamelHand> hands = [];
  final List<CamelHandJokerable> handsWithJokers = [];
  for (int i = 0; i < input.length; i++) {
    final [cards, bid] = input[i].split(' ');
    final cardsSplit = cards.split('');
    final int bidValue = int.parse(bid);
    hands.add(CamelHand(cards: cardsSplit, bid: bidValue, index: i));
    handsWithJokers
        .add(CamelHandJokerable(cards: cardsSplit, bid: bidValue, index: i)..generateUpdatedCardsWithWildcards());
  }
  hands.sort();
  handsWithJokers.sort();
  int scoreSum = 0;
  int scoreSumWithJokers = 0;
  for (final hand in hands) {
    hand.rank = hands.indexOf(hand) + 1;
    scoreSum += hand.getScore();
  }
  for (final hand in handsWithJokers) {
    hand.rank = handsWithJokers.indexOf(hand) + 1;
    scoreSumWithJokers += hand.getScore();
  }
  print(scoreSum);
  print(scoreSumWithJokers);
}
