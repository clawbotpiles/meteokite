import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WindMapPage extends StatelessWidget {
  const WindMapPage({super.key, required this.spotName});

  final String spotName;

  static const _cells = <_WindCell>[
    _WindCell(x: 0.15, y: 0.20, deg: 105, knots: 17),
    _WindCell(x: 0.34, y: 0.24, deg: 110, knots: 19),
    _WindCell(x: 0.55, y: 0.20, deg: 118, knots: 21),
    _WindCell(x: 0.75, y: 0.24, deg: 122, knots: 20),
    _WindCell(x: 0.18, y: 0.44, deg: 98, knots: 15),
    _WindCell(x: 0.38, y: 0.46, deg: 106, knots: 18),
    _WindCell(x: 0.60, y: 0.44, deg: 114, knots: 23),
    _WindCell(x: 0.80, y: 0.46, deg: 120, knots: 22),
    _WindCell(x: 0.20, y: 0.68, deg: 92, knots: 14),
    _WindCell(x: 0.40, y: 0.68, deg: 100, knots: 16),
    _WindCell(x: 0.62, y: 0.70, deg: 109, knots: 19),
    _WindCell(x: 0.82, y: 0.70, deg: 116, knots: 18),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de viento')),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(39.0, -0.3),
              initialZoom: 7,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.meteokitev2_0',
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x332196F3), Color(0x339C27B0)],
              ),
            ),
          ),
          ..._cells.map(
            (cell) => Align(
              alignment: Alignment(cell.x * 2 - 1, cell.y * 2 - 1),
              child: _WindArrow(cell: cell),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Capa de viento · $spotName',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'kt',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WindCell {
  const _WindCell({
    required this.x,
    required this.y,
    required this.deg,
    required this.knots,
  });

  final double x;
  final double y;
  final int deg;
  final int knots;
}

class _WindArrow extends StatelessWidget {
  const _WindArrow({required this.cell});

  final _WindCell cell;

  @override
  Widget build(BuildContext context) {
    final color = switch (cell.knots) {
      < 15 => const Color(0xFF4FC3F7),
      < 20 => const Color(0xFF29B6F6),
      < 24 => const Color(0xFFFFD54F),
      _ => const Color(0xFFFF8A65),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Transform.rotate(
              angle: (cell.deg * math.pi) / 180,
              child: Icon(Icons.near_me_rounded, size: 22, color: color),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${cell.knots}',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
          ),
        ),
      ],
    );
  }
}
