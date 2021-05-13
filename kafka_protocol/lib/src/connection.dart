part of kafka_protocol;

abstract class KafkaConnection {
  StreamSink<List<int>> get outputSink;

  Stream<List<int>> get inputStream;

  Future<void> close();
}

class _SocketKafkaConnection implements KafkaConnection {
  final Socket socket;

  _SocketKafkaConnection(this.socket);

  @override
  IOSink get outputSink {
    return socket;
  }

  @override
  Stream<List<int>> get inputStream {
    return socket;
  }

  @override
  Future<void> close() async {
    await socket.flush();
    return socket.close();
  }
}

Future<KafkaConnection> connectSocket(String host, {int port = 9092, Duration? timeout}) async {
  final socket = await Socket.connect(host, port, timeout: timeout);
  return _SocketKafkaConnection(socket);
}
