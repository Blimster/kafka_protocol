part of message_generator;

enum MessageType { request, response }

MessageType messageTypeFromString(String value) {
  for (var type in MessageType.values) {
    if (type.name == value.toLowerCase()) {
      return type;
    }
  }
  throw ArgumentError('$value is unsupported!');
}

class Field {
  final String name;
  final bool isArray;

  Field(this.name, this.isArray);

  @override
  String toString() {
    return '$name${isArray ? '*' : ''}';
  }
}

class Type {
  final String name;
  final List<Field> fields;
  final List<Type> subtypes;

  Type(this.name, this.fields, this.subtypes);

  @override
  String toString() {
    return 'Type(name=$name, fields=$fields, subtypes=$subtypes)';
  }
}

class Message extends Type {
  final MessageType type;
  final int version;

  Message(
    this.type,
    this.version,
    String name,
    List<Field> fields,
    List<Type> types,
  ) : super(name, fields, types);

  @override
  String toString() {
    return 'Message(name=$name, type=${type.name}, version=$version, fields=$fields, subtypes=$subtypes)';
  }
}

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

int levelOfLine(String line) {
  final leadingSpaces = line.length - line.trimLeft().length;
  return leadingSpaces ~/ 2;
}

Field parseField(String field) {
  var name = field;
  var isArray = false;
  if (field.startsWith('[') && field.endsWith(']')) {
    isArray = true;
    name = field.substring(1, field.length - 1);
  }
  return Field(name, isArray);
}

Type parseType(int level, List<String> lines) {
  final line = lines.removeAt(0).trim();
  final typeTokens = line.split('=>');

  final name = typeTokens[0].trim();
  final fields = typeTokens[1]
      .trim()
      .split(' ')
      .map((e) => e.trim())
      .map(parseField)
      .toList();

  final types = parseTypes(level + 1, lines);

  return Type(name, fields, types);
}

List<Type> parseTypes(int level, List<String> lines) {
  final result = <Type>[];
  while (lines.isNotEmpty && levelOfLine(lines[0]) == level) {
    result.add(parseType(level, lines));
  }
  return result;
}

String nameOf(Field field) {
  return field.name.camelCase;
}

String typeOf(Field field, List<Type> types) {
  if (field.name == 'TAG_BUFFER') {
    return 'KTagBuffer';
  }
  if (field.isArray) {
    return 'KArray';
  }

  for (var type in types) {
    if (type.name == field.name) {
      if (type.fields.length == 1) {
        return 'K${type.fields[0].name.pascalCase}';
      } else {
        return field.name.pascalCase;
      }
    }
  }

  throw StateError('Can´t find type for with name ${field.name}!');
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

final headerParams = [
  {
    'correlationId': 'KInt32',
  },
  {
    'correlationId': 'KInt32',
    'clientId': 'KNullableString',
  },
  {
    'correlationId': 'KInt32',
    'clientId': 'KNullableString',
    'headerTagBuffer': 'KTagBuffer',
  },
];

final typeMappings = {
  'KInt16': 'int',
  'KInt32': 'int',
  'KNullableString': 'String?',
  'KCompactString': 'String',
};

void writeRequestMessage(
    Message message, String className, List<String> content) {
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
    Message message, String className, List<String> content) {
  content.add('// TODO implement response');
}

void writeMessage(String filename, Message message) {
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

  File('lib/src/messages/$filename').writeAsStringSync(content.join('\n'));
}

void updateLibraryParts(List<String> filenames) {
  final file = File('../package/lib/src/messages/');
  print(file.absolute.path);
  // final filename = 'lib/kafka_protocol.dart';
  // final oldContent = File(filename).readAsLinesSync();
  // final newContent =
  //     oldContent.where((line) => !line.startsWith("part 'src/messages/"));

  // File(filename).writeAsStringSync([
  //   ...newContent,
  //   ...filenames.map((name) => "part 'src/messages/$name';").toList(),
  // ].join('\n'));
}

void generate() {
  print('Reading messages.txt...');
  final lines = File('lib/messages.txt').readAsLinesSync();
  print('${lines.length} lines read!');

  final messageLines = groupToMessages(lines);
  final messages = messageLines.map(parseMessage).toList();

  final filenames = <String>[];
  for (var message in messages) {
    final name =
        '${message.name.snakeCase}_v${message.version}_${message.type.name}.dart';
    filenames.add(name);
    // writeMessage(name, message);
  }

  updateLibraryParts(filenames);
}
