import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:nettskjema/nettskjema.dart' as n;

void main() {

  final Map<String, String> testdata = {
    "user_id":  "payload user_id",
    "key":      "payload key",
    "index":    "payload index",
    "value":    "payload value",
    "category": "payload category",
    "timestamp": DateTime.now().toUtc().toIso8601String(),
  };
  final int nettskjemaId = 127682;
  final Map<String, int> expectedFields = {
    'user_id': 1727233,
    'timestamp': 1727234,
    'key': 1727235,
    'index': 1727237,
    'value': 1727236,
    'category': 1727239
  }; 

  test('nettskjemaPublicMatchesExpectedFields', () async {
    expect(n.matchesExpectedSchemaFieldsPub(
      nettskjemaFields: ["1", "2", "3"],
      expectedFields: ["1", "2", "3"],
    ), true);
    expect(n.matchesExpectedSchemaFieldsPub(
      nettskjemaFields: ["1", "2"     ],
      expectedFields:   ["1", "2", "3"],
    ), false);
    expect(n.matchesExpectedSchemaFieldsPub(
      nettskjemaFields: ["1", "2", "3"],
      expectedFields:   [     "2", "3"],
    ), false);
  });

  test('nettskjemaPulicGetFieldNames online', () async {
    final r = await n.getSchemaFieldsPub(nettskjemaId);
    expect(r, expectedFields);
    expect(n.matchesExpectedSchemaFieldsPub(
      expectedFields: r.keys.toList(), 
      nettskjemaFields: expectedFields.keys.toList()
    ), true);
  });

  test('nettskjemaPublicUpload online', () async {
    await n.uploadSchemaPub(
      nettskjemaId: nettskjemaId,
      fieldNames: expectedFields,
      data: testdata,
    );
    expect(true, true);
    try {
      await n.uploadSchemaPub(
        nettskjemaId: nettskjemaId,
        fieldNames: expectedFields,
        data: {"sdf": "sdfsdf"},
      );
      fail("FieldIdMatchException not thrown");
    } catch (e) {
      expect(e, isInstanceOf<n.FieldIdMatchException>());
    }
  });

  test('NettskjemaPublic', () async {
    n.NettskjemaPublic nsp = n.NettskjemaPublic(nettskjemaId: nettskjemaId);
    await nsp.upload(testdata);
  });
  test('NettskjemaPublic offline', () async {
    final Map<String, String> d = {
      "bad": "testdata"
    };
    n.NettskjemaPublic nsp = n.NettskjemaPublic(nettskjemaId: nettskjemaId);
    try {
      await nsp.upload(d);
      fail("exception not thrown");
    } catch (e) {
      expect(e, isInstanceOf<SocketException>());
    }
  });
}
