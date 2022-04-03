part of kafka_protocol;

class ApiVersionsRequestV1 extends KafkaRequestV1 {
  ApiVersionsRequestV1({
    required KInt32 correlationId,
    required KNullableString clientId,
  }) : super._(
          ApiKey.apiVersions.key,
          KInt16(1),
          correlationId,
          clientId,
        );

  @override
  List<int> _serializePayload() {
    return [
    ];
  }
}
