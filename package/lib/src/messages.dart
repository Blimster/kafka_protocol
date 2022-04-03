part of kafka_protocol;

abstract class KafkaRequest {
  KafkaRequest._();

  List<int> serialize() {
    final message = [
      ..._serializeHeader(),
      ..._serializePayload(),
    ];
    return [
      ...KInt32(message.length).serialize(),
      ...message,
    ];
  }

  List<int> _serializeHeader();
  List<int> _serializePayload();
}

abstract class KafkaRequestV0 extends KafkaRequest {
  final KInt16 apiKey;
  final KInt16 apiVersion;
  final KInt32 correlationId;

  KafkaRequestV0._(this.apiKey, this.apiVersion, this.correlationId)
      : super._();

  @override
  List<int> _serializeHeader() {
    return [
      ...apiKey.serialize(),
      ...apiVersion.serialize(),
      ...correlationId.serialize(),
    ];
  }
}

abstract class KafkaRequestV1 extends KafkaRequestV0 {
  final KNullableString clientId;

  KafkaRequestV1._(
      KInt16 apiKey, KInt16 apiVersion, KInt32 correlationId, this.clientId)
      : super._(apiKey, apiVersion, correlationId);

  @override
  List<int> _serializeHeader() {
    return [
      ...super._serializeHeader(),
      ...clientId.serialize(),
    ];
  }
}

abstract class KafkaRequestV2 extends KafkaRequestV1 {
  final KTagBuffer headerTagBuffer;

  KafkaRequestV2._(
    KInt16 apiKey,
    KInt16 apiVersion,
    KInt32 correlationId,
    KNullableString clientId,
    this.headerTagBuffer,
  ) : super._(apiKey, apiVersion, correlationId, clientId);

  @override
  List<int> _serializeHeader() {
    return [
      ...super._serializeHeader(),
      ...headerTagBuffer.serialize(),
    ];
  }
}

abstract class KafkaResponse {
  late KInt32 _length;

  KafkaResponse._();

  Future<StreamReader> _apply(StreamReader reader) async {
    _length = await KInt32.fromReader(reader);
    final payload = await reader.takeCount(_length.value);
    return StreamReader(Stream.fromIterable([payload]));
  }

  int get length => _length.value + 4;
}

abstract class KafkaResponseV0 extends KafkaResponse {
  late KInt32 _correlationId;

  KafkaResponseV0._() : super._();

  @override
  Future<StreamReader> _apply(StreamReader reader) async {
    reader = await super._apply(reader);
    _correlationId = await KInt32.fromReader(reader);
    return reader;
  }

  int get correlationId => _correlationId.value;
}

abstract class KafkaResponseV1 extends KafkaResponseV0 {
  late KTagBuffer _headerTagBuffer;

  KafkaResponseV1._() : super._();

  @override
  Future<StreamReader> _apply(StreamReader reader) async {
    reader = await super._apply(reader);
    _headerTagBuffer = await KTagBuffer.fromReader(reader);
    return reader;
  }

  KTagBuffer get headerTagBuffer => _headerTagBuffer;
}
