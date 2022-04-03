part of kafka_protocol;

class _ResponseAndCompleter {
  final KafkaResponse response;
  final Completer<KafkaResponse> completer;

  _ResponseAndCompleter(this.response, this.completer);
}

class KafkaClient {
  final KafkaConnection _connection;
  final StreamReader _streamReader;
  final Queue<_ResponseAndCompleter> _pendingResponses = Queue();
  bool _isProccessingResponse = false;

  KafkaClient(this._connection)
      : _streamReader = StreamReader(_connection.inputStream);

  Future<R> request<R extends KafkaResponse>(
    KafkaRequest request,
    R response,
  ) async {
    final completer = Completer<R>();
    _pendingResponses.add(_ResponseAndCompleter(response, completer));
    _connection.outputSink.add(request.serialize());
    _processResponse(false);
    return completer.future;
  }

  void _processResponse(bool selfCall) {
    if (_isProccessingResponse == false || selfCall) {
      if (_pendingResponses.isNotEmpty) {
        _isProccessingResponse = true;
        final next = _pendingResponses.removeFirst();
        next.response._apply(_streamReader).then((value) {
          next.completer.complete(next.response);
          _processResponse(true);
        });
      } else {
        _isProccessingResponse = false;
      }
    }
  }
}
