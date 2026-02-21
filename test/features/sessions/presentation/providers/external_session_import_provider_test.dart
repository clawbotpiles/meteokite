import 'package:flutter_test/flutter_test.dart';
import 'package:meteokite/features/sessions/presentation/providers/external_session_import_provider.dart';

void main() {
  group('ExternalSessionImportService.importFromGpxXml', () {
    const service = ExternalSessionImportService();

    test('throws friendly error for malformed GPX', () {
      expect(
        () => service.importFromGpxXml('<gpx><trk></gpx>'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('invalido o corrupto'),
          ),
        ),
      );
    });

    test('throws when GPX does not have enough points', () {
      const gpx = '''
<gpx>
  <trk>
    <trkseg>
      <trkpt lat="36.5" lon="-6.2">
        <time>2026-02-21T10:00:00Z</time>
      </trkpt>
    </trkseg>
  </trk>
</gpx>
''';

      expect(
        () => service.importFromGpxXml(gpx),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('puntos suficientes'),
          ),
        ),
      );
    });

    test('parses valid GPX track summary', () {
      const gpx = '''
<gpx>
  <trk>
    <trkseg>
      <trkpt lat="36.5000" lon="-6.2000">
        <time>2026-02-21T10:00:00Z</time>
      </trkpt>
      <trkpt lat="36.5010" lon="-6.2000">
        <time>2026-02-21T10:10:00Z</time>
      </trkpt>
    </trkseg>
  </trk>
</gpx>
''';

      final imported = service.importFromGpxXml(gpx);

      expect(imported.source, 'gpx-file');
      expect(imported.durationMinutes, 10);
      expect(imported.distanceKm, greaterThan(0));
      expect(imported.avgSpeedKn, greaterThan(0));
      expect(imported.maxSpeedKn, greaterThan(0));
    });
  });
}
