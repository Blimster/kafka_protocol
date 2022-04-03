part of message_generator;

enum MessageType {
  request,
  response,
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
