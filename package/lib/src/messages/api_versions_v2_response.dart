part of kafka_protocol;

class ApiVersionsResponseV2 extends KafkaResponseV1 {
  ApiVersionsResponseV2() : super._();

  @override
  Future<StreamReader> _apply(StreamReader reader) async {
    reader = await super._apply(reader);
    return reader;
  }
}
