class SpotSeed {
  const SpotSeed({
    required this.name,
    required this.province,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String province;
  final double latitude;
  final double longitude;
}

abstract final class SpainInitialSpots {
  static const all = <SpotSeed>[
    SpotSeed(
      name: 'Oliva',
      province: 'Valencia',
      latitude: 38.919,
      longitude: -0.112,
    ),
    SpotSeed(
      name: 'Piles',
      province: 'Valencia',
      latitude: 38.944,
      longitude: -0.132,
    ),
    SpotSeed(
      name: 'Punta de los Molinos',
      province: 'Alicante',
      latitude: 38.843,
      longitude: 0.108,
    ),
    SpotSeed(
      name: 'Calpe',
      province: 'Alicante',
      latitude: 38.643,
      longitude: 0.057,
    ),
    SpotSeed(
      name: 'Altea',
      province: 'Alicante',
      latitude: 38.603,
      longitude: -0.050,
    ),
    SpotSeed(
      name: 'Villajoyosa',
      province: 'Alicante',
      latitude: 38.508,
      longitude: -0.232,
    ),
    SpotSeed(
      name: 'Santa Pola',
      province: 'Alicante',
      latitude: 38.193,
      longitude: -0.555,
    ),
    SpotSeed(
      name: 'Cullera',
      province: 'Valencia',
      latitude: 39.165,
      longitude: -0.252,
    ),
    SpotSeed(
      name: 'Xeraco',
      province: 'Valencia',
      latitude: 39.029,
      longitude: -0.193,
    ),
    SpotSeed(
      name: 'El Perellonet',
      province: 'Valencia',
      latitude: 39.305,
      longitude: -0.279,
    ),
    SpotSeed(
      name: 'Tarifa',
      province: 'Cadiz',
      latitude: 36.014,
      longitude: -5.604,
    ),
  ];
}
