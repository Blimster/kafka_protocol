part of kafka_protocol;

class ApiVersionsRequestV0 extends KafkaRequestV0 {
  ApiVersionsRequestV0({
    required KInt32 correlationId,
  }) : super._(
          ApiKey.apiVersions.key,
          KInt16(0),
          correlationId,
        );

  @override
  List<int> _serializePayload() {
    return [
    ];
  }
}
