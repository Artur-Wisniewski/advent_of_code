import '../utils.dart';
import 'main.dart';

void main() {
  void testDirection() {
    void testCanGoInDirection() {
      // north, west
      // vertical
      void test1() {
        final List<Directions> sideOnTile = [Directions.north, Directions.west];
        final TileTypes tileType = TileTypes.vertical;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        final bool canGoEast = tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile);
        assert(!canGoEast, 'Can\'t go east but canGoInDirection returns true');
      }

      // north, east
      // vertical
      void test2() {
        final List<Directions> sideOnTile = [Directions.north, Directions.east];
        final TileTypes tileType = TileTypes.vertical;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can\'t go west but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, west
      // vertical
      void test3() {
        final List<Directions> sideOnTile = [Directions.south, Directions.west];
        final TileTypes tileType = TileTypes.vertical;
        final bool canGoNorth = tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile);
        assert(canGoNorth, 'Can go north but canGoInDirection returns false');
        final bool canGoSouth = tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile);
        assert(canGoSouth, 'Can go south but canGoInDirection returns false');
        final bool canGoWest = tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile);
        assert(canGoWest, 'Can go west but canGoInDirection returns false');
        final bool canGoEast = tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile);
        assert(!canGoEast, 'Can\'t go east but canGoInDirection returns true');
      }

      // south, east
      // vertical
      void test4() {
        final List<Directions> sideOnTile = [Directions.south, Directions.east];
        final TileTypes tileType = TileTypes.vertical;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can\'t go west but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // north, west
      // horizontal
      void test5() {
        final List<Directions> sideOnTile = [Directions.north, Directions.west];
        final TileTypes tileType = TileTypes.horizontal;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can\'t go south but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // north, east
      // horizontal
      void test6() {
        final List<Directions> sideOnTile = [Directions.north, Directions.east];
        final TileTypes tileType = TileTypes.horizontal;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can\'t go south but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, west
      // horizontal
      void test7() {
        final List<Directions> sideOnTile = [Directions.south, Directions.west];
        final TileTypes tileType = TileTypes.horizontal;
        assert(!tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can\'t go north but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, east
      // horizontal
      void test8() {
        final List<Directions> sideOnTile = [Directions.south, Directions.east];
        final TileTypes tileType = TileTypes.horizontal;
        assert(!tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can\'t go north but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // north, west
      // northEast: L(╚)
      void test9() {
        final List<Directions> sideOnTile = [Directions.north, Directions.west];
        final TileTypes tileType = TileTypes.northEast;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // north, east
      // northEast: L(╚)
      void test10() {
        final List<Directions> sideOnTile = [Directions.north, Directions.east];
        final TileTypes tileType = TileTypes.northEast;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can\'t go south but canGoInDirection returns true');
        assert(!tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can\'t go west but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, west (bottom, left)
      // northEast: L(╚)
      void test11() {
        final List<Directions> sideOnTile = [Directions.south, Directions.west];
        final TileTypes tileType = TileTypes.northEast;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, east (bottom, right)
      // northEast: L(╚)
      void test12() {
        final List<Directions> sideOnTile = [Directions.south, Directions.east];
        final TileTypes tileType = TileTypes.northEast;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // north, west (top, left)
      // northWest: J(╝)
      void test13() {
        final List<Directions> sideOnTile = [Directions.north, Directions.west];
        final TileTypes tileType = TileTypes.northWest;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can\'t go south but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(!tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can\'t go east but canGoInDirection returns true');
      }

      // north, east (top, right)
      // northWest: J(╝)
      void test14() {
        final List<Directions> sideOnTile = [Directions.north, Directions.east];
        final TileTypes tileType = TileTypes.northWest;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, west
      // northWest: J(╝)
      void test15() {
        final List<Directions> sideOnTile = [Directions.south, Directions.west];
        final TileTypes tileType = TileTypes.northWest;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      // south, east
      // northWest: J(╝)
      void test16() {
        final List<Directions> sideOnTile = [Directions.south, Directions.east];
        final TileTypes tileType = TileTypes.northWest;
        assert(tileType.canGoInDirection(goTo: Directions.north, sideOnTile: sideOnTile),
            'Can go north but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.south, sideOnTile: sideOnTile),
            'Can go south but canGoInDirection returns false');
        assert(tileType.canGoInDirection(goTo: Directions.west, sideOnTile: sideOnTile),
            'Can go west but canGoInDirection returns true');
        assert(tileType.canGoInDirection(goTo: Directions.east, sideOnTile: sideOnTile),
            'Can go east but canGoInDirection returns false');
      }

      test1();
      test2();
      test3();
      test4();
      test5();
      test6();
      test7();
      test8();
      test9();
      test10();
      test11();
      test12();
      test13();
      test14();
      test15();
      test16();
    }

    testCanGoInDirection();
  }

  testDirection();
}
