part of message_generator;

List<List<String>> groupToMessages(List<String> lines) {
  final messages = <List<String>>[];
  var messageLines = <String>[];
  lines.where((line) => line.isNotEmpty).forEach((line) {
    if (!line.startsWith(' ')) {
      if (messageLines.isNotEmpty) {
        messages.add(messageLines);
        messageLines = [];
      }
    }
    messageLines.add(line);
  });
  if (messageLines.isNotEmpty) {
    messages.add(messageLines);
  }
  return messages;
}

Message parseMessage(List<String> lines) {
  final messageTokens =
      lines.removeAt(0).split('=>').map((e) => e.trim()).toList();

  final match = RegExp(r'^(\S*)\s*(Response|Request)\s*\(Version:\s*(\d*)\)$')
      .firstMatch(messageTokens[0])!;

  final type = messageTypeFromString(match[2]!);
  final version = int.parse(match[3]!);
  final name = match[1]!;

  final fields = messageTokens[1]
      .trim()
      .split(' ')
      .map((field) => field.trim())
      .where((field) => field.isNotEmpty)
      .map(parseField)
      .toList();

  final types = parseTypes(1, lines);

  return Message(
    type,
    version,
    name,
    fields,
    types,
  );
}

List<Message> readMessageFile() {
  final lines = File('lib/messages.txt').readAsLinesSync();

  final messageLines = groupToMessages(lines);
  return messageLines.map(parseMessage).toList();
}
