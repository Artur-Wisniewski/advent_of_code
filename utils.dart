import 'dart:io';

Future<List<String>> getInput() async {
  return await File('input.txt').readAsLines();
}