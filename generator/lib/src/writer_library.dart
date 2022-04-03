part of message_generator;

void writeLibraryParts(List<Message> messages) {
  final filename = '../package/lib/kafka_protocol.dart';
  final oldContent = File(filename).readAsLinesSync();
  final newContent =
      oldContent.where((line) => !line.startsWith("part 'src/messages/"));

  File(filename).writeAsStringSync([
    ...newContent,
    ...messages
        .map((message) => filenameForMessage(message))
        .map((name) => "part 'src/messages/$name';")
        .toList(),
  ].join('\n'));
}
