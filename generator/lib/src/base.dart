part of message_generator;

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

String filenameForMessage(Message message) {
  return '${message.name.snakeCase}_v${message.version}_${message.type.name}.dart';
}

int levelOfLine(String line) {
  final leadingSpaces = line.length - line.trimLeft().length;
  return leadingSpaces ~/ 2;
}

MessageType messageTypeFromString(String value) {
  for (var type in MessageType.values) {
    if (type.name == value.toLowerCase()) {
      return type;
    }
  }
  throw ArgumentError('$value is unsupported!');
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
