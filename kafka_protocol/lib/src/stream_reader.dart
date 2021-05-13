part of kafka_protocol;

class _StreamReader {
  final buffer = Queue<int>();
  final controller = StreamController<void>.broadcast();

  _StreamReader(Stream<List<int>> stream) {
    stream.listen(onData);
  }

  void onData(List<int> data) {
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
    final list = await takeCount(1);
    return list[0];
  }
}
