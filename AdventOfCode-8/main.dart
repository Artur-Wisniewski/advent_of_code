//--- Day 8: Haunted Wasteland ---

import '../utils.dart';

class Route {
  final String key;
  final String leftKey;
  final String rightKey;
  Route? leftRoute;
  Route? rightRoute;

  Route(this.key, {required this.leftKey, required this.rightKey});

  factory Route.fromTextLine(List<String> inputLines) {
    final [name, others] = inputLines[0].split(' = ');
    final [leftName, rightName] = others.substring(1, others.length - 1).split(', ');
    return Route(name, leftKey: leftName, rightKey: rightName);
  }

  void wireRoutes(List<Route> routes) {
    leftRoute = routes.firstWhere((route) => route.key == leftKey);
    rightRoute = routes.firstWhere((route) => route.key == rightKey);
  }
}

const startKey = 'AAA';
const endKey = 'ZZZ';
const startSymbol = 'A';
const endSymbol = 'Z';

Future<void> main() async {
  final inputLines = await getInput(fileName: 'input.txt');
  final instructions = inputLines[0].split('');
  final routesLines = inputLines.sublist(2);
  final routes = <Route>[];
  routes.addAll([
    for (final line in routesLines) Route.fromTextLine([line])
  ]);
  for (final route in routes) {
    route.wireRoutes(routes);
  }
  // Part #1
  int i = 0;
  Route currentRoute = routes.firstWhere((element) => element.key == startKey);
  for (;; ++i) {
    final instruction = instructions[i % (instructions.length)];
    if (currentRoute.key == endKey) {
      break;
    }
    if (instruction == 'L') {
      currentRoute = currentRoute.leftRoute!;
    } else if (instruction == 'R') {
      currentRoute = currentRoute.rightRoute!;
    }
  }
  print('PART1: Number of steps: $i');

  // Part #2
  List<Route> currentRoutes = routes.where((element) => element.key.endsWith(startSymbol)).toList();
  List<int> stepsList = [];
  for (final route in currentRoutes) {
    Route currentRoute = route;
    int steps = 0;
    for (;; ++steps) {
      final instruction = instructions[steps % (instructions.length)];
      if (currentRoute.key.endsWith(endSymbol)) {
        break;
      }
      if (instruction == 'L') {
        currentRoute = currentRoute.leftRoute!;
      } else if (instruction == 'R') {
        currentRoute = currentRoute.rightRoute!;
      }
    }
    stepsList.add(steps);
  }
  print('PART2: Number of steps: ${leastCommonMultipleList(stepsList)}');
}
