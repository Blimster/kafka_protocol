part of kafka_protocol;

class ApiVersionsResponseV0 extends KafkaResponseV0 {
  ApiVersionsResponseV0() : super._();

  @override
  Future<StreamReader> _apply(StreamReader reader) async {
    reader = await super._apply(reader);
    return reader;
  }
}
