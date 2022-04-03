part of kafka_protocol;

class ApiVersionsResponseV3 extends KafkaResponseV1 {
  ApiVersionsResponseV3() : super._();

  @override
  Future<StreamReader> _apply(StreamReader reader) async {
    reader = await super._apply(reader);
    return reader;
  }
}
