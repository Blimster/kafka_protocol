import 'package:kafka_protocol/kafka_protocol.dart';

void main() async {
  final request = ApiVersionsRequestV3(
      correlationId: KInt32(1910),
      clientId: KNullableString('kafka_dart'),
      headerTagBuffer: KTagBuffer(),
      clientSoftwareName: KCompactString('kafka_dart'),
      clientSoftwareVersion: KCompactString('kafka_dart'),
      tagBuffer: KTagBuffer());

  final connection = await connectSocket('localhost');
  final client = KafkaClient(connection);

  final response = await client.request(request, ApiVersionsResponseV3());
  print(response.length);
  print(response.correlationId);

  await connection.close();
}
