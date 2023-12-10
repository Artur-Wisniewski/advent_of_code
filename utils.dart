import 'dart:io';

final RegExp onlyNumbersRegExp = RegExp(r'\d+');

Future<List<String>> getInput({String fileName = 'input.txt'}) async {
  return await File(fileName).readAsLines();
}

int greatestCommonDivisor(int a, int b) => a.gcd(b);

int leastCommonMultiple(int a, int b) {
  if ((a == 0) || (b == 0)) {
    return 0;
  }
  return ((a ~/ greatestCommonDivisor(a, b)) * b).abs();
}

int leastCommonMultipleList(List<int> numbers) {
  int answer = 1;
  for (int number in numbers) {
    answer = leastCommonMultiple(answer, number);
  }
  return answer;
}
