import 'dart:io';

final RegExp onlyNumbersRegExp = RegExp(r'\d+');

Future<List<String>> getInput({String fileName = 'input.txt'}) async {
  return await File(fileName).readAsLines();
}
