import 'dart:io';

final RegExp onlyNumbersRegExp = RegExp(r'\d+');

Future<List<String>> getInput() async {
  return await File('input.txt').readAsLines();
}