import 'package:logger/logger.dart';

class CustomLogPrinter extends LogPrinter {
  final String className;
  CustomLogPrinter({required this.className});

  final logger = Logger();
  final _pretty = PrettyPrinter();

  @override
  List<String> log(LogEvent event) {
    var emoji = _pretty.levelEmojis?[event.level] ?? '';
    return ['$emoji $className - ${event.message}'];
  }
}
