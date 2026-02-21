class WindSnapshot {
  const WindSnapshot({
    required this.speedKn,
    required this.gustKn,
    required this.directionDeg,
    required this.timestamp,
    required this.source,
  });

  final double speedKn;
  final double gustKn;
  final int directionDeg;
  final DateTime timestamp;
  final String source;
}
