part of kafka_protocol;

class ApiVersionsRequestV2 extends KafkaRequestV2 {
  ApiVersionsRequestV2({
    required KInt32 correlationId,
    required KNullableString clientId,
    required KTagBuffer headerTagBuffer,
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
    ];
  }
}
