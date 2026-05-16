import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomLogOutput extends LogOutput {
  final _pretty = PrettyPrinter();
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      final colorFunc = _pretty.levelColors?[event.level];
      final outputLine = colorFunc != null ? colorFunc(line) : line;
      debugPrint(outputLine);
    }
  }
}
