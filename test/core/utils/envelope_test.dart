import 'package:flutter_test/flutter_test.dart';
import 'package:prro/core/utils/envelope.dart';

Map<String, dynamic> _row(int id) => {'id': id, 'name': 'row $id'};

Map<String, dynamic> _identity(Map<String, dynamic> json) => json;

void main() {
  group('unwrapList', () {
    test('unwraps a {data:[...]} envelope', () {
      final rows = unwrapList({
        'data': [_row(1), _row(2)],
        'error': null,
        'meta': {'request_id': 'x'},
      }, _identity);

      expect(rows.map((r) => r['id']), [1, 2]);
    });

    test('accepts a bare list', () {
      final rows = unwrapList([_row(3)], _identity);

      expect(rows.single['id'], 3);
    });

    test('returns an empty list for an unsupported shape', () {
      expect(unwrapList(null, _identity), isEmpty);
      expect(unwrapList({'data': null}, _identity), isEmpty);
      expect(unwrapList('nonsense', _identity), isEmpty);
    });

    test('skips non-map entries instead of throwing', () {
      final rows = unwrapList({
        'data': [_row(1), 'junk', null],
      }, _identity);

      expect(rows, hasLength(1));
    });
  });

  group('unwrapObject', () {
    test('unwraps a {data:{...}} envelope', () {
      final row = unwrapObject({'data': _row(9), 'error': null}, _identity);

      expect(row?['id'], 9);
    });

    test('accepts a bare object', () {
      final row = unwrapObject(_row(4), _identity);

      expect(row?['id'], 4);
    });

    test('returns null when there is no object to parse', () {
      expect(unwrapObject(null, _identity), isNull);
      expect(unwrapObject(42, _identity), isNull);
      expect(unwrapObject([_row(1)], _identity), isNull);
    });

    test('falls back to the envelope map itself when data is absent', () {
      // Deliberate tolerance: `{"data": null}` (or a non-object `data`) is
      // handed back as-is so a model can still read sibling top-level keys
      // instead of crashing.
      expect(unwrapObject({'data': null, 'id': 5}, _identity)?['id'], 5);
      expect(unwrapObject({'data': <dynamic>[], 'id': 6}, _identity)?['id'], 6);
    });
  });

  group('unwrapPayload', () {
    test('unwraps a {data:{...}} envelope', () {
      final payload = unwrapPayload({
        'data': _row(7),
        'error': null,
        'meta': {'request_id': 'x'},
      });

      expect(payload?['id'], 7);
    });

    test('accepts a bare object', () {
      expect(unwrapPayload(_row(2))?['id'], 2);
    });

    test('falls back to the envelope when data is not an object', () {
      // Same tolerance as unwrapObject: a `null`/list `data` hands the envelope
      // back so the model can read sibling top-level keys.
      expect(unwrapPayload({'data': null, 'id': 8})?['id'], 8);
      expect(unwrapPayload({'data': <dynamic>[], 'id': 9})?['id'], 9);
    });

    test('returns null when the body carries no object at all', () {
      expect(unwrapPayload(null), isNull);
      expect(unwrapPayload(42), isNull);
      expect(unwrapPayload('nonsense'), isNull);
      expect(unwrapPayload(<dynamic>[_row(1)]), isNull);
    });
  });

  group('unwrapData', () {
    test('returns the data value of an envelope', () {
      expect(unwrapData({'data': _row(1), 'error': null}), _row(1));
    });

    test('returns null for an explicitly empty payload', () {
      // Presence-based, unlike unwrapPayload: this is how the stub
      // `PUT /variants/:id/recipe` response is detected.
      expect(unwrapData({'data': null}), isNull);
    });

    test('returns the body itself when there is no data key', () {
      expect(unwrapData(_row(3)), _row(3));
      expect(unwrapData(null), isNull);
    });
  });
}
