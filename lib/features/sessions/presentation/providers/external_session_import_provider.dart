import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xml/xml.dart';

class ImportedSessionData {
  const ImportedSessionData({
    required this.durationMinutes,
    required this.distanceKm,
    required this.avgSpeedKn,
    required this.maxSpeedKn,
    required this.source,
  });

  final int durationMinutes;
  final double distanceKm;
  final double avgSpeedKn;
  final double maxSpeedKn;
  final String source;
}

class ExternalSessionImportService {
  const ExternalSessionImportService();

  Future<ImportedSessionData?> importFromGpxFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['gpx'],
    );

    final pickedPath = result?.files.single.path;
    if (pickedPath == null || pickedPath.isEmpty) {
      return null;
    }

    final file = File(pickedPath);
    if (!await file.exists()) {
      throw StateError('Archivo GPX no encontrado.');
    }

    final xmlText = await file.readAsString();
    return importFromGpxXml(xmlText);
  }

  ImportedSessionData importFromGpxXml(String xmlText) {
    final document = _parseGpxDocument(xmlText);
    final points = _extractPoints(document);
    if (points.length < 2) {
      throw StateError('El archivo GPX no contiene puntos suficientes.');
    }

    double distanceMeters = 0;
    double maxSpeedKn = 0;
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final meters = Geolocator.distanceBetween(
        prev.lat,
        prev.lon,
        curr.lat,
        curr.lon,
      );
      if (meters.isFinite && meters > 0) {
        distanceMeters += meters;
      }

      if (prev.time != null && curr.time != null) {
        final seconds = curr.time!.difference(prev.time!).inMilliseconds / 1000;
        if (seconds > 0) {
          final speedMs = meters / seconds;
          final speedKn = speedMs * 1.94384;
          if (speedKn > maxSpeedKn) {
            maxSpeedKn = speedKn;
          }
        }
      }
    }

    final start = points.first.time;
    final end = points.last.time;
    final durationMinutes = (start != null && end != null)
        ? end.difference(start).inMinutes.clamp(1, 24 * 60).toInt()
        : 1;

    final distanceKm = distanceMeters / 1000;
    final durationHours = durationMinutes / 60.0;
    final avgSpeedKn = durationHours > 0
        ? distanceKm / durationHours / 1.852
        : 0.0;

    return ImportedSessionData(
      durationMinutes: durationMinutes,
      distanceKm: distanceKm,
      avgSpeedKn: avgSpeedKn,
      maxSpeedKn: maxSpeedKn > 0 ? maxSpeedKn : avgSpeedKn,
      source: 'gpx-file',
    );
  }

  Future<ImportedSessionData> importDemo({required String source}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    switch (source) {
      case 'WOO':
        return const ImportedSessionData(
          durationMinutes: 104,
          distanceKm: 21.4,
          avgSpeedKn: 17.8,
          maxSpeedKn: 31.2,
          source: 'woo',
        );
      case 'Garmin/Watch':
        return const ImportedSessionData(
          durationMinutes: 92,
          distanceKm: 18.0,
          avgSpeedKn: 15.6,
          maxSpeedKn: 25.1,
          source: 'watch',
        );
      case 'FIT/GPX':
      default:
        return const ImportedSessionData(
          durationMinutes: 88,
          distanceKm: 16.9,
          avgSpeedKn: 14.9,
          maxSpeedKn: 24.0,
          source: 'fit-gpx',
        );
    }
  }

  XmlDocument _parseGpxDocument(String xmlText) {
    try {
      return XmlDocument.parse(xmlText);
    } on XmlException {
      throw StateError('Archivo GPX invalido o corrupto.');
    }
  }

  List<_GpxPoint> _extractPoints(XmlDocument document) {
    final points = <_GpxPoint>[];
    final nodes = document.findAllElements('trkpt');

    for (final node in nodes) {
      final lat = double.tryParse(node.getAttribute('lat') ?? '');
      final lon = double.tryParse(node.getAttribute('lon') ?? '');
      if (lat == null || lon == null) {
        continue;
      }

      final timeNode = node.getElement('time');
      final time = timeNode == null
          ? null
          : DateTime.tryParse(timeNode.innerText.trim());

      points.add(_GpxPoint(lat: lat, lon: lon, time: time?.toUtc()));
    }

    return points;
  }
}

class _GpxPoint {
  const _GpxPoint({required this.lat, required this.lon, required this.time});

  final double lat;
  final double lon;
  final DateTime? time;
}

final externalSessionImportServiceProvider =
    Provider<ExternalSessionImportService>((ref) {
      return const ExternalSessionImportService();
    });
