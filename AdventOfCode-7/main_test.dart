import 'main.dart';

void main(){
  testCamelHandJokerable();
}

void testCamelHandJokerable (){

    // J5745
    void testGenerateUpdatedCardsWithWildcards1() {
      final CamelHandJokerable camelHandJokerable = CamelHandJokerable(cards: ['J', '5', '7', '4', '5'], bid: 1, index: 0);
      camelHandJokerable.generateUpdatedCardsWithWildcards();
      assert(camelHandJokerable.cards.toString() == '[5, 5, 7, 4, 5]', 'Failed, expected [5, 5, 7, 4, 5], got ${camelHandJokerable.cards}');
    }

    // AJA82
    void testGenerateUpdatedCardsWithWildcards2() {
      final CamelHandJokerable camelHandJokerable = CamelHandJokerable(cards: ['A', 'J', 'A', '8', '2'], bid: 1, index: 0);
      camelHandJokerable.generateUpdatedCardsWithWildcards();
      assert(camelHandJokerable.cards.toString() == '[A, A, A, 8, 2]', 'Failed, expected [A, A, A, 8, 2], got ${camelHandJokerable.cards}');
    }

    // 9JQJQ
    void testGenerateUpdatedCardsWithWildcards3() {
      final CamelHandJokerable camelHandJokerable = CamelHandJokerable(cards: ['9', 'J', 'Q', 'J', 'Q'], bid: 1, index: 0);
      camelHandJokerable.generateUpdatedCardsWithWildcards();
      assert(camelHandJokerable.cards.toString() == '[9, Q, Q, Q, Q]', 'Failed, expected [9, Q, Q, Q, Q], got ${camelHandJokerable.cards}');
    }

    // 99QJQ
    void testGenerateUpdatedCardsWithWildcards4() {
      final CamelHandJokerable camelHandJokerable = CamelHandJokerable(cards: ['9', '9', 'Q', 'J', 'Q'], bid: 1, index: 0);
      camelHandJokerable.generateUpdatedCardsWithWildcards();
      assert(camelHandJokerable.cards.toString() == '[9, 9, Q, Q, Q]', 'Failed, expected [9, 9, Q, Q, Q], got ${camelHandJokerable.cards}');
    }

    testGenerateUpdatedCardsWithWildcards1();
    testGenerateUpdatedCardsWithWildcards2();
    testGenerateUpdatedCardsWithWildcards3();
    testGenerateUpdatedCardsWithWildcards4();
}