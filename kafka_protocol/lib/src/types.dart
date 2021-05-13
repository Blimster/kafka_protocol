part of kafka_protocol;

abstract class KafkaType<T> {
  final T value;

  KafkaType(this.value);

  List<int> serialize();
}

class Int16 extends KafkaType<int> {
  Int16(int value) : super(value);

  static Int16 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return Int16(bytes.buffer.asByteData().getInt16(0, Endian.big));
  }

  static Future<Int16> fromReader(_StreamReader reader) async {
    final list = await reader.takeCount(2);
    return Int16.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(2);
    bytes.buffer.asByteData().setInt16(0, value, Endian.big);
    return bytes.toList();
  }
}

class Int32 extends KafkaType<int> {
  Int32(int value) : super(value);

  static Int32 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return Int32(bytes.buffer.asByteData().getInt32(0, Endian.big));
  }

  static Future<Int32> fromReader(_StreamReader reader) async {
    final list = await reader.takeCount(2);
    return Int32.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(4);
    bytes.buffer.asByteData().setInt32(0, value, Endian.big);
    return bytes.toList();
  }
}

class Varint extends KafkaType<int> {
  Varint(int value) : super(value);

  static Varint fromList(List<int> list) {
    var result = 0;
    for (var byte in list.reversed) {
      result |= (byte & 0x7f);
      result <<= 7;
    }
    result >>= 7;
    return Varint((result >> 1) ^ (-(result & 1)));
  }

  static Future<Varint> fromReader(_StreamReader reader) async {
    final list = <int>[];
    var byte;
    do {
      byte = await reader.takeOne();
      list.add(byte);
    } while (byte & 0x80 == 0x80);
    return fromList(list);
  }

  @override
  List<int> serialize() {
    final result = <int>[];
    var zigZag = (value << 1) ^ (value >> 31);
    while (zigZag >= 0x80) {
      result.add(0x80 | (zigZag & 0x7f));
      zigZag >>= 7;
    }
    result.add(zigZag);
    return result;
  }
}

class CompactString extends KafkaType<String> {
  CompactString(String value) : super(value);

  @override
  List<int> serialize() {
    final encoded = utf8.encode(value);
    return [...Varint(encoded.length + 1).serialize(), ...encoded];
  }
}

class NullableString extends KafkaType<String?> {
  NullableString(String? value) : super(value);

  @override
  List<int> serialize() {
    final value = this.value;
    if (value != null) {
      final encoded = utf8.encode(value);
      return [...Int16(encoded.length).serialize(), ...encoded];
    } else {
      return Int16(-1).serialize();
    }
  }
}

class TagBuffer extends KafkaType<Map<Varint, KafkaType>> {
  TagBuffer() : super({});

  TagBuffer fromList(List<int> list) {
    return TagBuffer();
  }

  Future<TagBuffer> fromReader(_StreamReader reader) async {
    return fromList([]);
  }

  @override
  List<int> serialize() {
    return Varint(value.length).serialize();
  }
}
