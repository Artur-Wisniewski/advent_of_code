import '../utils.dart';

//--- Day 6: Wait For It ---

class Race {
  final int duration;
  final int distanceRecord;

  const Race({required this.duration, required this.distanceRecord});

  int findBeatingHoldingStrategiesCount(){
    final List<int> strategies = [];
    int testCaseLeft = duration ~/ 2;
    int testCaseRight = testCaseLeft+1;
    while(testCaseLeft > 0 || testCaseRight < duration) {
      if((testCaseLeft > 0) && (calculateDistanceAtHoldingTime(time: testCaseLeft) > distanceRecord)) {
        strategies.add(testCaseLeft);
        testCaseLeft--;
      } else {
        testCaseLeft = 0;
      }
      if((testCaseRight < duration) && (calculateDistanceAtHoldingTime(time: testCaseRight) > distanceRecord)) {
        strategies.add(testCaseRight);
        testCaseRight++;
      } else {
        testCaseRight = duration;
      }
    }
    return strategies.length;
  }

  int calculateDistanceAtHoldingTime({required int time}) {
    assert(duration > time);
    return time * (duration-time);
  }
}

Future<void> main() async {
  final inputText = await getInput(fileName: 'input.txt');
  final [_, durationsText] = inputText[0].split(':');
  final [_, distancesText] = inputText[1].split(':');
  final durations = onlyNumbersRegExp.allMatches(durationsText).map((e) => int.parse(e.group(0)!)).toList();
  final distances = onlyNumbersRegExp.allMatches(distancesText).map((e) => int.parse(e.group(0)!)).toList();
  int multiplication = 1;
  for (int i = 0; i < durations.length; i++) {
    final strategiesNumber = Race(duration: durations[i], distanceRecord: distances[i]).findBeatingHoldingStrategiesCount();
    print(strategiesNumber);
    multiplication *= strategiesNumber;
  }
  print(multiplication);

  // part 2
  final durations2 = onlyNumbersRegExp.allMatches(durationsText).map((e) => e.group(0)).toList();
  final distances2 = onlyNumbersRegExp.allMatches(distancesText).map((e) => e.group(0)).toList();
  final StringBuffer bufferDuration = StringBuffer();
  final StringBuffer bufferDistance = StringBuffer();
  for(int i = 0; i < durations2.length; i++) {
    bufferDuration.write(durations2[i]);
    bufferDistance.write(distances2[i]);
  }
  final race = Race(duration: int.parse(bufferDuration.toString()), distanceRecord: int.parse(bufferDistance.toString()));
  print(race.findBeatingHoldingStrategiesCount());
}
