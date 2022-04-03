part of kafka_protocol;

abstract class KafkaType<T> {
  final T value;

  KafkaType(this.value);

  List<int> serialize();
}

class KBoolean extends KafkaType<bool> {
  KBoolean(bool value) : super(value);

  static KBoolean fromList(List<int> list) {
    return KBoolean(list[0] > 0);
  }

  static Future<KBoolean> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(1);
    return KBoolean.fromList(list);
  }

  @override
  List<int> serialize() {
    return [value ? 1 : 0];
  }
}

class KInt8 extends KafkaType<int> {
  KInt8(int value) : super(value);

  static KInt8 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KInt8(bytes.buffer.asByteData().getInt8(0));
  }

  static Future<KInt8> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(1);
    return KInt8.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(1);
    bytes.buffer.asByteData().setInt8(0, value);
    return bytes.toList();
  }
}

class KInt16 extends KafkaType<int> {
  KInt16(int value) : super(value);

  static KInt16 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KInt16(bytes.buffer.asByteData().getInt16(0, Endian.big));
  }

  static Future<KInt16> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(2);
    return KInt16.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(2);
    bytes.buffer.asByteData().setInt16(0, value, Endian.big);
    return bytes.toList();
  }
}

class KInt32 extends KafkaType<int> {
  KInt32(int value) : super(value);

  static KInt32 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KInt32(bytes.buffer.asByteData().getInt32(0, Endian.big));
  }

  static Future<KInt32> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(4);
    return KInt32.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(4);
    bytes.buffer.asByteData().setInt32(0, value, Endian.big);
    return bytes.toList();
  }
}

class KInt64 extends KafkaType<int> {
  KInt64(int value) : super(value);

  static KInt64 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KInt64(bytes.buffer.asByteData().getInt64(0, Endian.big));
  }

  static Future<KInt64> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(8);
    return KInt64.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(8);
    bytes.buffer.asByteData().setInt64(0, value, Endian.big);
    return bytes.toList();
  }
}

class KUInt32 extends KafkaType<int> {
  KUInt32(int value) : super(value);

  static KUInt32 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KUInt32(bytes.buffer.asByteData().getUint32(0, Endian.big));
  }

  static Future<KUInt32> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(4);
    return KUInt32.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(4);
    bytes.buffer.asByteData().setUint32(0, value, Endian.big);
    return bytes.toList();
  }
}

class KVarint extends KafkaType<int> {
  KVarint(int value) : super(value);

  static KVarint fromList(List<int> list) {
    var index = -1;
    do {
      index++;
    } while (list[index] & 0x80 == 0x80);
    final bytes = list.sublist(0, index + 1);

    var result = 0;
    for (var byte in bytes.reversed) {
      result |= (byte & 0x7f);
      result <<= 7;
    }
    result >>= 7;
    return KVarint((result >> 1) ^ (-(result & 1)));
  }

  static Future<KVarint> fromReader(StreamReader reader) async {
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

class KUuid extends KafkaType<UuidValue> {
  KUuid(UuidValue value) : super(value);

  static KUuid fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KUuid(UuidValue.fromByteList(bytes));
  }

  static Future<KUuid> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(16);
    return KUuid.fromList(list);
  }

  @override
  List<int> serialize() {
    return value.toBytes().buffer.asUint8List().toList();
  }
}

class KFloat64 extends KafkaType<double> {
  KFloat64(double value) : super(value);

  static KFloat64 fromList(List<int> list) {
    final bytes = Uint8List.fromList(list);
    return KFloat64(bytes.buffer.asByteData().getFloat64(0, Endian.big));
  }

  static Future<KFloat64> fromReader(StreamReader reader) async {
    final list = await reader.takeCount(8);
    return KFloat64.fromList(list);
  }

  @override
  List<int> serialize() {
    final bytes = Uint8List(8);
    bytes.buffer.asByteData().setFloat64(0, value, Endian.big);
    return bytes.toList();
  }
}

class KString extends KafkaType<String> {
  KString(String value) : super(value);

  static KString fromList(List<int> list) {
    return KString(utf8.decode(list.sublist(2)));
  }

  static Future<KString> fromReader(StreamReader reader) async {
    final length = await reader.takeCount(2);
    final encoded = await reader.takeCount(KInt16.fromList(length).value);
    return KString.fromList([
      ...length,
      ...encoded,
    ]);
  }

  @override
  List<int> serialize() {
    final encoded = utf8.encode(value);
    return [
      ...KInt16(encoded.length).serialize(),
      ...encoded,
    ];
  }
}

class KCompactString extends KafkaType<String> {
  KCompactString(String value) : super(value);

  static KCompactString fromList(List<int> list) {
    final length = KVarint.fromList(list);
    return KCompactString(utf8.decode(list.sublist(length.serialize().length)));
  }

  static Future<KCompactString> fromReader(StreamReader reader) async {
    final length = await KVarint.fromReader(reader);
    final payload = await reader.takeCount(length.value - 1);
    return fromList([
      ...length.serialize(),
      ...payload,
    ]);
  }

  @override
  List<int> serialize() {
    final encoded = utf8.encode(value);
    return [
      ...KVarint(encoded.length + 1).serialize(),
      ...utf8.encode(value),
    ];
  }
}

class KNullableString extends KafkaType<String?> {
  KNullableString(String? value) : super(value);

  static KNullableString fromList(List<int> list) {
    final length = KInt16.fromList(list);
    if (length.value == -1) {
      return KNullableString(null);
    }
    return KNullableString(utf8.decode(list.sublist(2, 2 + length.value)));
  }

  static Future<KNullableString> fromReader(StreamReader reader) async {
    final length = await KInt16.fromReader(reader);
    final payload =
        length.value == -1 ? <int>[] : await reader.takeCount(length.value);
    return fromList([
      ...length.serialize(),
      ...payload,
    ]);
  }

  @override
  List<int> serialize() {
    final value = this.value;
    if (value != null) {
      final encoded = utf8.encode(value);
      return [...KInt16(encoded.length).serialize(), ...encoded];
    } else {
      return KInt16(-1).serialize();
    }
  }
}

class KTagBuffer extends KafkaType<Map<KVarint, KafkaType>> {
  KTagBuffer() : super({});

  static KTagBuffer fromList(List<int> list) {
    return KTagBuffer();
  }

  static Future<KTagBuffer> fromReader(StreamReader reader) async {
    await KVarint.fromReader(reader);
    return fromList([]);
  }

  @override
  List<int> serialize() {
    return KVarint(value.length).serialize();
  }
}
