part of kafka_protocol;

class StreamReader {
  final buffer = Queue<int>();
  final controller = StreamController<void>.broadcast();

  StreamReader(Stream<List<int>> stream) {
    stream.listen(_onData);
  }

  void _onData(List<int> data) {
    buffer.addAll(data);
    controller.add(null);
  }

  Future<List<int>> takeCount(int count) {
    final completer = Completer<List<int>>();
    final buffer = <int>[];
    final subscription = controller.stream.listen(null);

    subscription.onData((_) {
      while (buffer.length < count && this.buffer.isNotEmpty) {
        buffer.add(this.buffer.removeFirst());
      }
      if (buffer.length == count) {
        subscription.cancel();
        completer.complete(buffer);
      }
    });
    controller.add(null);

    return completer.future;
  }

  Future<int> takeOne() async {
    return (await takeCount(1))[0];
  }
}
