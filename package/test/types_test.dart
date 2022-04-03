import 'package:kafka_protocol/kafka_protocol.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

StreamReader createSR(List<int> input) {
  return StreamReader(Stream.fromIterable([input]));
}

void main() {
  group('KBoolean', () {
    test('encode/decode', () async {
      final resultFalse =
          await KBoolean.fromReader(createSR(KBoolean(false).serialize()));
      expect(resultFalse.value, equals(false));

      final resultTrue =
          await KBoolean.fromReader(createSR(KBoolean(true).serialize()));
      expect(resultTrue.value, equals(true));
    });
  });

  group('KInt8', () {
    test('encode/decode', () async {
      final resultMax =
          await KInt8.fromReader(createSR(KInt8(127).serialize()));
      expect(resultMax.value, equals(127));

      final resultMin =
          await KInt8.fromReader(createSR(KInt8(-128).serialize()));
      expect(resultMin.value, equals(-128));
    });
  });

  group('KInt16', () {
    test('encode/decode', () async {
      final resultMax =
          await KInt16.fromReader(createSR(KInt16(32767).serialize()));
      expect(resultMax.value, equals(32767));

      final resultMin =
          await KInt16.fromReader(createSR(KInt16(-32768).serialize()));
      expect(resultMin.value, equals(-32768));
    });
  });

  group('KInt32', () {
    test('encode/decode', () async {
      final resultMax =
          await KInt32.fromReader(createSR(KInt32(2147483647).serialize()));
      expect(resultMax.value, equals(2147483647));

      final resultMin =
          await KInt32.fromReader(createSR(KInt32(-2147483648).serialize()));
      expect(resultMin.value, equals(-2147483648));
    });
  });

  group('KInt64', () {
    test('encode/decode', () async {
      final resultMax = await KInt64.fromReader(
          createSR(KInt64(9223372036854775807).serialize()));
      expect(resultMax.value, equals(9223372036854775807));

      final resultMin = await KInt64.fromReader(
          createSR(KInt64(-9223372036854775808).serialize()));
      expect(resultMin.value, equals(-9223372036854775808));
    });
  });

  group('KUInt32', () {
    test('encode/decode', () async {
      final resultMax =
          await KUInt32.fromReader(createSR(KUInt32(4294967295).serialize()));
      expect(resultMax.value, equals(4294967295));

      final resultMin =
          await KUInt32.fromReader(createSR(KUInt32(0).serialize()));
      expect(resultMin.value, equals(0));
    });
  });

  group('KVarint', () {
    test('encode/decode', () async {
      final resultMax =
          await KVarint.fromReader(createSR(KVarint(2147483647).serialize()));
      expect(resultMax.value, equals(2147483647));

      final resultMin =
          await KVarint.fromReader(createSR(KVarint(-2147483648).serialize()));
      expect(resultMin.value, equals(-2147483648));
    });
  });

  group('KUuid', () {
    test('encode/decode', () async {
      final uuid = Uuid().v4obj();
      final result = await KUuid.fromReader(createSR(KUuid(uuid).serialize()));
      expect(result.value, equals(uuid));
    });
  });

  group('KFloat64', () {
    test('encode/decode', () async {
      final resultMax =
          await KFloat64.fromReader(createSR(KFloat64(1234.5678).serialize()));
      expect(resultMax.value, equals(1234.5678));

      final resultMin =
          await KFloat64.fromReader(createSR(KFloat64(-1234.5678).serialize()));
      expect(resultMin.value, equals(-1234.5678));
    });
  });

  group('KString', () {
    test('encode/decode', () async {
      final result = await KString.fromReader(
          createSR(KString('hello world').serialize()));
      expect(result.value, equals('hello world'));

      final resultEmpty =
          await KString.fromReader(createSR(KString('').serialize()));
      expect(resultEmpty.value, equals(''));
    });
  });

  group('KCompactString', () {
    test('encode/decode', () async {
      final result = await KCompactString.fromReader(
          createSR(KCompactString('hello world').serialize()));
      expect(result.value, equals('hello world'));

      final resultEmpty = await KCompactString.fromReader(
          createSR(KCompactString('').serialize()));
      expect(resultEmpty.value, equals(''));
    });
  });

  group('KNullableString', () {
    test('encode/decode', () async {
      // final result = await KNullableString.fromReader(
      //     createSR(KNullableString('hello world').serialize()));
      // expect(result.value, equals('hello world'));

      // final resultEmpty = await KNullableString.fromReader(
      //     createSR(KNullableString('').serialize()));
      // expect(resultEmpty.value, equals(''));

      final resultNull = await KNullableString.fromReader(
          createSR(KNullableString(null).serialize()));
      expect(resultNull.value, isNull);
    });
  });
}
