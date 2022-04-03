part of kafka_protocol;

class ApiVersionsResponseV1 extends KafkaResponseV1 {
  ApiVersionsResponseV1() : super._();

  @override
  Future<StreamReader> _apply(StreamReader reader) async {
    reader = await super._apply(reader);
    return reader;
  }
}
