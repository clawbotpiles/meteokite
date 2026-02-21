class GearPreset {
  const GearPreset({
    required this.name,
    required this.type,
    this.size,
    this.notes,
  });

  final String name;
  final String type;
  final String? size;
  final String? notes;
}

class DisciplineGearPresets {
  static List<GearPreset> forDiscipline(String discipline) {
    switch (discipline.toLowerCase()) {
      case 'kitesurf':
        return const [
          GearPreset(name: 'Kite freeride', type: 'kite', size: '9m'),
          GearPreset(name: 'Twintip', type: 'tabla', size: '138'),
          GearPreset(name: 'Arnes', type: 'accesorio'),
        ];
      case 'wingfoil':
        return const [
          GearPreset(name: 'Wing all-round', type: 'wing', size: '5m'),
          GearPreset(name: 'Tabla foil', type: 'tabla', size: '95L'),
          GearPreset(name: 'Mast foil', type: 'foil', size: '85cm'),
        ];
      case 'windsurf':
        return const [
          GearPreset(name: 'Vela freeride', type: 'vela', size: '5.5m'),
          GearPreset(name: 'Tabla freeride', type: 'tabla', size: '120L'),
          GearPreset(name: 'Mastil', type: 'accesorio'),
        ];
      default:
        return const [GearPreset(name: 'Equipo principal', type: 'equipo')];
    }
  }
}
