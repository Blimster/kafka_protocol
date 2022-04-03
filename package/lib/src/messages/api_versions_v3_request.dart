part of kafka_protocol;

class ApiVersionsRequestV3 extends KafkaRequestV2 {
  final KCompactString clientSoftwareName;
  final KCompactString clientSoftwareVersion;
  final KTagBuffer tagBuffer;
  ApiVersionsRequestV3({
    required KInt32 correlationId,
    required KNullableString clientId,
    required KTagBuffer headerTagBuffer,
    required this.clientSoftwareName,
    required this.clientSoftwareVersion,
    required this.tagBuffer,
  }) : super._(
          ApiKey.apiVersions.key,
          KInt16(2),
          correlationId,
          clientId,
          headerTagBuffer,
        );

  @override
  List<int> _serializePayload() {
    return [
      ...clientSoftwareName.serialize(),
      ...clientSoftwareVersion.serialize(),
      ...tagBuffer.serialize(),
    ];
  }
}
