import 'package:kafka_protocol/kafka_protocol.dart';

void main() async {
  print(Varint.fromList(Varint(300).serialize()).value);
  print(Varint.fromList(Varint(3000).serialize()).value);
  print(Varint.fromList(Varint(30000).serialize()).value);
  // final connection = await connectSocket('localhost');
  // print('connected');
  // connection.outputSink.add(ApiVersionsRequest().serialize());
  // connection.inputStream.listen((event) {
  //   print(event.length);
  //   print(event);
  // });
  // await connection.close();
  // print('disconnected');
}
