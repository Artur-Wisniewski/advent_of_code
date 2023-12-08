import '../utils.dart';

///--- Day 1: Trebuchet?! ---

extension on String {
  int parseToInt() {
    return switch (this) {
      'one' => 1,
      'two' => 2,
      'three' => 3,
      'four' => 4,
      'five' => 5,
      'six' => 6,
      'seven' => 7,
      'eight' => 8,
      'nine' => 9,
      '' => 0,
      _ => int.parse(this),
    };
  }
}

const numbersPattern = r'(?=(one|two|three|four|five|six|seven|eight|nine|\d))';
const onlyDigitsPattern = r'[1-9]';

int? getValue(String line, {bool onlyDigits = false}) {
  final numbers = RegExp(onlyDigits ? onlyDigitsPattern : numbersPattern)
      .allMatches(line)
      .map((e) => onlyDigits ? e.group(0) : e.group(1));
  final firstNumber = numbers.first;
  final lastNumber = numbers.last;
  if (firstNumber == null || lastNumber == null) {
    return null;
  }
  return firstNumber.parseToInt() * 10 + lastNumber.parseToInt();
}

Future<void> main() async {
  final inputText = await getInput();
  int sum = 0;
  int sumOnlyDigits = 0;
  for (final line in inputText) {
    sum += getValue(line) ?? 0;
    sumOnlyDigits += getValue(line, onlyDigits: true) ?? 0;
  }
  print(sumOnlyDigits);
  print(sum);
}
