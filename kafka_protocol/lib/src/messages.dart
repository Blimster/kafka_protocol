part of kafka_protocol;

int _correlationId = 123;

abstract class KafkaRequest {
  final Int16 apiKey;
  final Int16 apiVersion;
  final Int32 correlationId;
  final NullableString clientId;

  KafkaRequest(this.apiKey, this.apiVersion, this.clientId) : correlationId = Int32(_correlationId++);

  List<int> serialize() {
    final message = [
      ...apiKey.serialize(),
      ...apiVersion.serialize(),
      ...correlationId.serialize(),
      ...clientId.serialize(),
      ..._serializePayload(),
    ];
    return [...Int32(message.length).serialize(), ...message];
  }

  List<int> _serializePayload();
}

class ApiVersionsRequest extends KafkaRequest {
  final CompactString clientSoftwareName;
  final CompactString clientSoftwareVersion;
  final TagBuffer taggedFields;

  ApiVersionsRequest({String? clientId})
      : clientSoftwareName = CompactString('kafka_protocol'),
        clientSoftwareVersion = CompactString('0.1.0'),
        taggedFields = TagBuffer(),
        super(Int16(18), Int16(2), NullableString(clientId));

  @override
  List<int> _serializePayload() {
    return [
      ...clientSoftwareName.serialize(),
      ...clientSoftwareVersion.serialize(),
      ...taggedFields.serialize(),
    ];
  }
}

abstract class KafkaResponse {
  final Int32 correlationId;
  final TagBuffer taggedFields;

  KafkaResponse(this.correlationId, this.taggedFields);
}

class ApiKey {
  final Int16 apiKey;
  final Int16 minVersion;
  final Int16 maxVersion;
  ApiKey(this.apiKey, this.minVersion, this.maxVersion);
}

class ApiVersioinsResponse extends KafkaResponse {
  final Int16 errorCode;
  final List<ApiKey> apiKeys;
  final Int32 throttleTimeMs;

  ApiVersioinsResponse(
    Int32 correlationId,
    TagBuffer taggedFields,
    this.errorCode,
    this.apiKeys,
    this.throttleTimeMs,
  ) : super(correlationId, taggedFields);
}
