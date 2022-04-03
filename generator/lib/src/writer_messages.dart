part of message_generator;

void writeRequestMessage(
  Message message,
  String className,
  List<String> content,
) {
  final version = min(2, message.version);

  content.add('class $className extends KafkaRequestV$version {');
  message.fields
      .map((e) => '  final ${typeOf(e, message.subtypes)} ${nameOf(e)};')
      .forEach(content.add);
  content.add('  $className({');
  headerParams[version]
      .entries
      .map((e) => '    required ${e.value} ${e.key},')
      .forEach(content.add);
  message.fields
      .map((e) => '    required this.${nameOf(e)},')
      .forEach(content.add);
  content.add('  }) : super._(');
  content.add('          ApiKey.${message.name.camelCase}.key,');
  content.add('          KInt16($version),');
  headerParams[version]
      .entries
      .map((e) => '          ${e.key},')
      .forEach(content.add);
  content.add('        );');
  content.add('');
  content.add('  @override');
  content.add('  List<int> _serializePayload() {');
  content.add('    return [');
  message.fields
      .map((e) => '      ...${nameOf(e)}.serialize(),')
      .forEach(content.add);
  content.add('    ];');
  content.add('  }');
  content.add('}');
}

void writeResponseMessage(
  Message message,
  String className,
  List<String> content,
) {
  final version = min(1, message.version);

  content.add('class $className extends KafkaResponseV$version {');
  content.add('  $className() : super._();');
  content.add('');
  content.add('  @override');
  content.add('  Future<StreamReader> _apply(StreamReader reader) async {');
  content.add('    reader = await super._apply(reader);');
  content.add('    return reader;');
  content.add('  }');
  content.add('}');
}

void writeMessage(Message message) {
  final className =
      '${message.name}${message.type.name.pascalCase}V${message.version}';
  final content = <String>[];
  content.add('part of kafka_protocol;');
  content.add('');
  switch (message.type) {
    case MessageType.request:
      writeRequestMessage(message, className, content);
      break;
    case MessageType.response:
      writeResponseMessage(message, className, content);
  }
  content.add('');

  File('../package/lib/src/messages/${filenameForMessage(message)}')
      .writeAsStringSync(content.join('\n'));
}

void writeMessages(List<Message> messages) {
  for (var message in messages) {
    writeMessage(message);
  }
}
