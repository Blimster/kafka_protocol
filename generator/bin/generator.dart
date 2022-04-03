import 'package:kafka_protocol_message_generator/messge_generator.dart';

void main(List<String> arguments) {
  final messages = readMessageFile();
  writeMessages(messages);
  writeLibraryParts(messages);
}
