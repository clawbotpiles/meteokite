import 'package:flutter/material.dart';
import 'package:meteokitev2_0/core/theme/app_spacing.dart';
import 'package:meteokitev2_0/features/community/presentation/pages/community_user_profile_page.dart';
import 'package:meteokitev2_0/features/community/presentation/pages/community_user_sessions_page.dart';
import 'package:meteokitev2_0/features/sessions/presentation/pages/session_detail_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  static const int _pageSize = 50;
  static const List<_KpiFilterOption> _kpiOrderOptions = [
    _KpiFilterOption.metric('salto_mas_alto', 'Salto mas alto', 'm'),
    _KpiFilterOption.metric('big_air_score', 'Big Air score', 'pts'),
    _KpiFilterOption.metric('numero_saltos', 'Numero de saltos', 'count'),
    _KpiFilterOption.divider(),
    _KpiFilterOption.group('Core Session'),
    _KpiFilterOption.metric('duracion_total', 'Duracion total', 'min'),
    _KpiFilterOption.metric('tiempo_activo', 'Tiempo activo', 'min'),
    _KpiFilterOption.metric('tiempo_parado', 'Tiempo parado', 'min'),
    _KpiFilterOption.metric('ratio_activo_parado', 'Ratio activo/parado', 'x'),
    _KpiFilterOption.metric('distancia_total', 'Distancia total', 'km'),
    _KpiFilterOption.metric('distancia_planeo', 'Distancia en planeo', 'km'),
    _KpiFilterOption.metric('distancia_upwind', 'Distancia upwind', 'km'),
    _KpiFilterOption.metric('distancia_downwind', 'Distancia downwind', 'km'),
    _KpiFilterOption.metric('velocidad_media', 'Velocidad media', 'kt'),
    _KpiFilterOption.metric('velocidad_max', 'Velocidad maxima', 'kt'),
    _KpiFilterOption.metric('velocidad_p95', 'Top velocidad estable', 'kt'),
    _KpiFilterOption.metric('racha_max', 'Racha maxima', 'kt'),
    _KpiFilterOption.metric('racha_10s', 'Racha sostenida (10s)', 'kt'),
    _KpiFilterOption.metric('transiciones', 'Transiciones', 'count'),
    _KpiFilterOption.metric(
      'transiciones_hora',
      'Transiciones por hora',
      'count/h',
    ),
    _KpiFilterOption.group('Big Air'),
    _KpiFilterOption.metric('top5_saltos', 'Top 5 saltos', 'm'),
    _KpiFilterOption.metric(
      'altura_media_saltos',
      'Altura media de saltos',
      'm',
    ),
    _KpiFilterOption.metric('hangtime_max', 'Hangtime maximo', 's'),
    _KpiFilterOption.metric('hangtime_p95', 'Top hangtime estable', 's'),
    _KpiFilterOption.metric(
      'eficiencia_salto_viento',
      'Eficiencia salto/viento',
      'm/kt',
    ),
    _KpiFilterOption.metric(
      'cadencia_saltos',
      'Cadencia de saltos',
      'min/salto',
    ),
    _KpiFilterOption.metric(
      'consistencia_alturas',
      'Variacion de alturas',
      '%',
    ),
    _KpiFilterOption.group('Freestyle'),
    _KpiFilterOption.metric('intentos_truco', 'Intentos por trick', 'count'),
    _KpiFilterOption.metric('exito_truco', 'Tasa de exito por trick', '%'),
    _KpiFilterOption.metric('combo_rate', 'Combo rate', '%'),
    _KpiFilterOption.metric('dificultad_media', 'Dificultad media', '/10'),
    _KpiFilterOption.metric('caidas_intento', 'Caidas por intento', 'count'),
    _KpiFilterOption.metric('progresion_truco', 'Progresion por trick', '%'),
    _KpiFilterOption.group('Freeride / Navegacion'),
    _KpiFilterOption.metric('vmg_upwind', 'Velocidad efectiva upwind', 'kt'),
    _KpiFilterOption.metric(
      'vmg_downwind',
      'Velocidad efectiva downwind',
      'kt',
    ),
    _KpiFilterOption.metric('angulo_cenida', 'Angulo de cenida', 'deg'),
    _KpiFilterOption.metric('eficiencia_bordos', 'Eficiencia de bordos', '%'),
    _KpiFilterOption.metric('tiempo_sweetspot', 'Tiempo en sweet spot', '%'),
    _KpiFilterOption.metric('deriva_neta', 'Deriva neta', 'km'),
    _KpiFilterOption.metric('cobertura_area', 'Cobertura de area', 'km2'),
    _KpiFilterOption.group('Saltos'),
    _KpiFilterOption.metric('takeoff_speed', 'Takeoff speed', 'kt'),
    _KpiFilterOption.metric('landing_speed', 'Fuerza G al aterrizar', 'G'),
    _KpiFilterOption.metric('clean_landing_rate', 'Clean landing rate', '%'),
    _KpiFilterOption.metric('impact_score', 'Impact score', '/10'),
    _KpiFilterOption.group('Control tecnico'),
    _KpiFilterOption.metric(
      'variabilidad_velocidad',
      'Variabilidad de velocidad',
      'kt',
    ),
    _KpiFilterOption.metric(
      'estabilidad_direccional',
      'Estabilidad direccional',
      '%',
    ),
    _KpiFilterOption.metric('calidad_jibe', 'Calidad del giro downwind', '%'),
    _KpiFilterOption.metric(
      'perdida_vel_transiciones',
      'Perdida vel. en transiciones',
      'kt',
    ),
    _KpiFilterOption.metric(
      'recuperacion_planeo',
      'Recuperacion de planeo',
      's',
    ),
    _KpiFilterOption.metric('smoothness_score', 'Smoothness score', '/10'),
    _KpiFilterOption.group('Condiciones meteo-contexto'),
    _KpiFilterOption.metric('viento_medio', 'Viento medio', 'kt'),
    _KpiFilterOption.metric('viento_rango', 'Rango de viento', 'kt'),
    _KpiFilterOption.metric(
      'direccion_dominante',
      'Direccion dominante',
      'deg',
    ),
    _KpiFilterOption.metric('gust_factor', 'Gust factor', 'x'),
    _KpiFilterOption.metric('temperatura', 'Temperatura', 'C'),
    _KpiFilterOption.metric('presion', 'Presion', 'hPa'),
    _KpiFilterOption.metric('lluvia', 'Lluvia', 'bin'),
    _KpiFilterOption.group('Seguridad y riesgo'),
    _KpiFilterOption.metric('caidas_hora', 'Caidas por hora', 'count/h'),
    _KpiFilterOption.metric(
      'eventos_sobrepotencia',
      'Eventos de sobrepotencia',
      'count',
    ),
    _KpiFilterOption.metric(
      'distancia_max_costa',
      'Distancia maxima a costa',
      'km',
    ),
    _KpiFilterOption.metric(
      'tiempo_zona_riesgo',
      'Tiempo en zona de riesgo',
      'min',
    ),
    _KpiFilterOption.metric('alertas_atendidas', 'Alertas atendidas', '%'),
    _KpiFilterOption.metric('fatiga_estimada', 'Fatiga estimada', '%'),
    _KpiFilterOption.group('Dispositivo y calidad de datos'),
    _KpiFilterOption.metric('bateria_hora', 'Bateria por hora', '%/h'),
    _KpiFilterOption.metric('calidad_gps', 'Calidad GPS', '%'),
    _KpiFilterOption.metric('samples_perdidos', 'Samples perdidos', '%'),
    _KpiFilterOption.metric('latencia_sync', 'Latencia de sincronizacion', 's'),
    _KpiFilterOption.metric('health_dataset', 'Health score del dataset', '%'),
    _KpiFilterOption.group('KPIs compuestos'),
    _KpiFilterOption.metric('session_score', 'Session score', 'pts'),
    _KpiFilterOption.metric('freestyle_score', 'Freestyle score', 'pts'),
    _KpiFilterOption.metric('freeride_score', 'Freeride score', 'pts'),
    _KpiFilterOption.metric('safety_score', 'Safety score', 'pts'),
    _KpiFilterOption.metric('progress_score', 'Progress score', 'pts'),
  ];

  final ScrollController _leaderboardScrollController = ScrollController();

  _CommunityTab _selectedTab = _CommunityTab.leaderboard;
  String _draftPeriod = '7d';
  String _draftSpot = 'Todos';
  String _draftScope = 'Global';
  String _draftOrder = 'salto_mas_alto';

  String _appliedPeriod = '7d';
  String _appliedSpot = 'Todos';
  String _appliedScope = 'Global';
  String _appliedOrder = 'salto_mas_alto';
  bool _showLeaderboardFilters = false;

  int _visibleLeaderboardCount = _pageSize;

  final String _myUsername = 'you_rider';

  final Set<String> _followingUsernames = {
    'air_lucas',
    'mara_bigair',
    'nico_loop',
  };

  late final List<_CommunityUser> _users = _buildMockUsers();

  final List<_FollowingSession> _sessions = [
    _FollowingSession(
      username: 'air_lucas',
      title: 'Sesion sunset en Tarifa',
      spot: 'Tarifa',
      dateLabel: '23/02 18:40',
      endedAt: DateTime(2026, 2, 23, 18, 40),
      bigAirScore: 987,
      highestJumpMeters: 22.4,
      distanceKm: 34.7,
      durationLabel: '01:12:00',
      equipmentLabel: 'Core XR8 + Jaime SLS (fase 2)',
      likesCount: 184,
      hasSessionPhoto: true,
    ),
    _FollowingSession(
      username: 'mara_bigair',
      title: 'Training Big Air',
      spot: 'Fuerteventura',
      dateLabel: '23/02 16:20',
      endedAt: DateTime(2026, 2, 23, 16, 20),
      bigAirScore: 972,
      highestJumpMeters: 21.7,
      distanceKm: 29.4,
      durationLabel: '00:58:00',
      equipmentLabel: 'Dice + Atmos (fase 2)',
      likesCount: 132,
      hasSessionPhoto: false,
    ),
    _FollowingSession(
      username: 'nico_loop',
      title: 'Viento racheado pero bueno',
      spot: 'Tarifa',
      dateLabel: '22/02 14:05',
      endedAt: DateTime(2026, 2, 22, 14, 05),
      bigAirScore: 948,
      highestJumpMeters: 20.9,
      distanceKm: 41.2,
      durationLabel: '01:26:00',
      equipmentLabel: 'Orbit + Spectrum (fase 2)',
      likesCount: 96,
      hasSessionPhoto: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _leaderboardScrollController.addListener(_onLeaderboardScroll);
  }

  @override
  void dispose() {
    _leaderboardScrollController.dispose();
    super.dispose();
  }

  void _onLeaderboardScroll() {
    if (!_leaderboardScrollController.hasClients) {
      return;
    }
    final maxScroll = _leaderboardScrollController.position.maxScrollExtent;
    final offset = _leaderboardScrollController.offset;
    if (maxScroll - offset <= 220) {
      final total = _leaderboardRows().length;
      if (_visibleLeaderboardCount < total) {
        setState(() {
          final nextCount = _visibleLeaderboardCount + _pageSize;
          _visibleLeaderboardCount = nextCount > total ? total : nextCount;
        });
      }
    }
  }

  List<_CommunityUser> _buildMockUsers() {
    const spots = [
      'Tarifa',
      'Fuerteventura',
      'Gandia',
      'Oliva Norte',
      'El Medano',
    ];
    final users = <_CommunityUser>[
      const _CommunityUser(
        username: 'air_lucas',
        bigAirScore: 987,
        highestJumpMeters: 22.4,
        mainSpot: 'Tarifa',
        avatarColor: Color(0xFF1565C0),
      ),
      const _CommunityUser(
        username: 'mara_bigair',
        bigAirScore: 972,
        highestJumpMeters: 21.7,
        mainSpot: 'Fuerteventura',
        avatarColor: Color(0xFF6A1B9A),
      ),
      const _CommunityUser(
        username: 'nico_loop',
        bigAirScore: 948,
        highestJumpMeters: 20.9,
        mainSpot: 'Tarifa',
        avatarColor: Color(0xFF2E7D32),
      ),
      const _CommunityUser(
        username: 'sofi_wind',
        bigAirScore: 931,
        highestJumpMeters: 19.8,
        mainSpot: 'Gandia',
        avatarColor: Color(0xFFEF6C00),
      ),
      const _CommunityUser(
        username: 'alex_wave',
        bigAirScore: 924,
        highestJumpMeters: 19.3,
        mainSpot: 'Oliva Norte',
        avatarColor: Color(0xFF00838F),
      ),
      const _CommunityUser(
        username: 'you_rider',
        bigAirScore: 886,
        highestJumpMeters: 16.8,
        mainSpot: 'Tarifa',
        avatarColor: Color(0xFF37474F),
      ),
      const _CommunityUser(
        username: 'javi_foil',
        bigAirScore: 882,
        highestJumpMeters: 16.4,
        mainSpot: 'El Medano',
        avatarColor: Color(0xFF5D4037),
      ),
      const _CommunityUser(
        username: 'lucia_jump',
        bigAirScore: 879,
        highestJumpMeters: 16.1,
        mainSpot: 'Gandia',
        avatarColor: Color(0xFFAD1457),
      ),
      const _CommunityUser(
        username: 'kike_wave',
        bigAirScore: 875,
        highestJumpMeters: 15.9,
        mainSpot: 'Tarifa',
        avatarColor: Color(0xFF283593),
      ),
      const _CommunityUser(
        username: 'nora_loop',
        bigAirScore: 871,
        highestJumpMeters: 15.7,
        mainSpot: 'Oliva Norte',
        avatarColor: Color(0xFF00695C),
      ),
    ];

    for (var i = 0; i < 260; i++) {
      final score = 860 - (i * 2);
      final jump = 15.8 - ((i % 37) * 0.06);
      users.add(
        _CommunityUser(
          username: 'rider_${i + 1}',
          bigAirScore: score,
          highestJumpMeters: jump < 7.2 ? 7.2 : jump,
          mainSpot: spots[i % spots.length],
          avatarColor: Colors.primaries[i % Colors.primaries.length].shade400,
        ),
      );
    }
    return users;
  }

  List<_LeaderboardRow> _leaderboardRows() {
    Iterable<_CommunityUser> filtered = _users;

    if (_appliedScope == 'Friends') {
      filtered = filtered.where(
        (u) => _followingUsernames.contains(u.username),
      );
    }
    if (_appliedSpot != 'Todos') {
      filtered = filtered.where((u) => u.mainSpot == _appliedSpot);
    }

    final rows = filtered
        .map(
          (u) =>
              _LeaderboardRow(user: u, score: _scoreForPeriod(u.bigAirScore)),
        )
        .toList();

    rows.sort((a, b) => _metricSortValue(b).compareTo(_metricSortValue(a)));

    return rows;
  }

  int _scoreForPeriod(int baseScore) {
    switch (_appliedPeriod) {
      case '24h':
        return baseScore - 22;
      case '7d':
        return baseScore;
      case '30d':
        return baseScore - 11;
      case 'All time':
      default:
        return baseScore + 7;
    }
  }

  void _applyFilters() {
    setState(() {
      _appliedPeriod = _draftPeriod;
      _appliedSpot = _draftSpot;
      _appliedScope = _draftScope;
      _appliedOrder = _draftOrder;
      _visibleLeaderboardCount = _pageSize;
    });
    if (_leaderboardScrollController.hasClients) {
      _leaderboardScrollController.jumpTo(0);
    }
  }

  void _openProfile(String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityUserProfilePage(username: username),
      ),
    );
  }

  void _openSessions(String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityUserSessionsPage(username: username),
      ),
    );
  }

  void _openFriendSessionDetail(_FollowingSession session) {
    final insights = SessionInsightData.fromSession(
      title: session.title,
      deviceName: 'Woo Sports',
      deviceKind: 'Woo Sports',
      endedAt: session.endedAt,
      durationLabel: session.durationLabel,
    );

    final summary =
        'Sesion en ${session.spot} con salto maximo ${session.highestJumpMeters.toStringAsFixed(1)} m y ${session.distanceKm.toStringAsFixed(1)} km recorridos.';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SessionDetailPage(
          title: session.title,
          deviceName: 'Woo Sports',
          endedAt: session.endedAt,
          durationLabel: session.durationLabel,
          summary: summary,
          hasSessionPhoto: session.hasSessionPhoto,
          sessionMediaLabel: session.hasSessionPhoto
              ? 'Foto subida por el usuario'
              : 'Mapa del spot (fallback)',
          insights: insights,
        ),
      ),
    );
  }

  Future<void> _openLeaderboardActions(_CommunityUser user) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_rounded),
                title: const Text('Ver perfil'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openProfile(user.username);
                },
              ),
              ListTile(
                leading: const Icon(Icons.surfing_rounded),
                title: const Text('Ver sesiones'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openSessions(user.username);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openFriendsDirectory() async {
    final searchController = TextEditingController();
    String query = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final friends = _followedUsers()
                .where(
                  (u) => u.username.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  top: AppSpacing.md,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Buscar entre tus amigos',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Cerrar',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Buscar amigo',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setSheetState(() {
                          query = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 320,
                      child: friends.isEmpty
                          ? const Center(
                              child: Text('No hay amigos para esta busqueda.'),
                            )
                          : ListView.builder(
                              itemCount: friends.length,
                              itemBuilder: (context, index) {
                                final user = friends[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user.avatarColor,
                                  ),
                                  title: Text('@${user.username}'),
                                  subtitle: Text(
                                    'Big Air ${user.bigAirScore} · Salto ${user.highestJumpMeters.toStringAsFixed(1)} m',
                                  ),
                                  trailing: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _openProfile(user.username);
                                    },
                                    child: const Text('Ver perfil'),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    searchController.dispose();
  }

  List<_CommunityUser> _followedUsers() {
    return _users
        .where((u) => _followingUsernames.contains(u.username))
        .toList();
  }

  List<_FollowingSession> _followingSessions() {
    return _sessions
        .where((s) => _followingUsernames.contains(s.username))
        .toList();
  }

  Color? _podiumTint(int index) {
    switch (index) {
      case 0:
        return const Color(0x14C9A227);
      case 1:
        return const Color(0x14000000);
      case 2:
        return const Color(0x14A97142);
      default:
        return null;
    }
  }

  Color? _podiumBorder(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFC9A227);
      case 1:
        return const Color(0xFF9E9E9E);
      case 2:
        return const Color(0xFFA97142);
      default:
        return null;
    }
  }

  IconData? _podiumIcon(int index) {
    switch (index) {
      case 0:
        return Icons.workspace_premium_rounded;
      case 1:
        return Icons.military_tech_rounded;
      case 2:
        return Icons.military_tech_outlined;
      default:
        return null;
    }
  }

  _KpiFilterOption _selectedMetricOption() {
    return _kpiOrderOptions.firstWhere(
      (o) => o.key == _appliedOrder,
      orElse: () => _kpiOrderOptions.first,
    );
  }

  String _leaderboardMetricText(_LeaderboardRow row) {
    final value = _metricSortValue(row);
    final unit = _selectedMetricOption().unit;
    if (unit == 'count' || unit == 'count/h') {
      return unit == 'count'
          ? value.toStringAsFixed(0)
          : '${value.toStringAsFixed(1)} $unit';
    }
    if (unit == '%') {
      return '${value.toStringAsFixed(0)} %';
    }
    if (unit == 'min') {
      return '${value.toStringAsFixed(0)} min';
    }
    if (unit == 'pts') {
      return '${value.toStringAsFixed(0)} pts';
    }
    if (unit == 'bin') {
      return value >= 0.5 ? 'si' : 'no';
    }
    return '${value.toStringAsFixed(1)} $unit';
  }

  String _leaderboardMetricHeader() {
    final option = _selectedMetricOption();
    if (option.unit == 'count' || option.unit == 'bin') {
      return option.label;
    }
    return '${option.label} (${option.unit})';
  }

  int _userSeed(_CommunityUser user) {
    return user.username.codeUnits.fold(0, (sum, c) => sum + c);
  }

  double _metricSortValue(_LeaderboardRow row) {
    final seed = _userSeed(row.user);
    switch (_appliedOrder) {
      case 'big_air_score':
        return row.score.toDouble();
      case 'salto_mas_alto':
        return row.user.highestJumpMeters;
      case 'numero_saltos':
        return 18 + (seed % 110);
      case 'hangtime_max':
        return (row.user.highestJumpMeters * 0.43) + ((seed % 9) * 0.05);
      case 'velocidad_max':
        return 21 + (seed % 160) / 10;
      case 'viento_medio':
        return 14 + (seed % 90) / 10;
      case 'distancia_total':
        return 6 + (seed % 190) / 10;
      case 'duracion_total':
        return 35 + (seed % 160);
      case 'consistencia_alturas':
        return 60 + (seed % 40);
      case 'vmg_upwind':
        return 10 + (seed % 90) / 10;
      case 'vmg_downwind':
        return 12 + (seed % 105) / 10;
      case 'lluvia':
        return seed % 2 == 0 ? 1 : 0;
      default:
        final option = _selectedMetricOption();
        if (option.unit == '%') {
          return 50 + (seed % 50);
        }
        if (option.unit == 'kt') {
          return 10 + (seed % 220) / 10;
        }
        if (option.unit == 'km' || option.unit == 'km2') {
          return 1 + (seed % 180) / 10;
        }
        if (option.unit == 's') {
          return 1 + (seed % 120) / 10;
        }
        if (option.unit == 'min') {
          return 20 + (seed % 190);
        }
        if (option.unit == 'deg') {
          return (seed % 360).toDouble();
        }
        if (option.unit == '/10') {
          return 4 + (seed % 60) / 10;
        }
        if (option.unit == 'x') {
          return 1 + (seed % 35) / 10;
        }
        if (option.unit == 'hPa') {
          return 1000 + (seed % 40);
        }
        if (option.unit == 'C') {
          return 10 + (seed % 25);
        }
        if (option.unit == 'count') {
          return 1 + (seed % 200);
        }
        return row.score.toDouble();
    }
  }

  Widget _buildLeaderboardCardRow(_LeaderboardRow row, int index) {
    final tint = _podiumTint(index);
    final borderColor = _podiumBorder(index);
    final podiumIcon = _podiumIcon(index);
    final isLeader = index == 0;

    return Card(
      color: tint,
      shape: borderColor == null
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: borderColor, width: 1.2),
            ),
      child: InkWell(
        onTap: () => _openLeaderboardActions(row.user),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: isLeader ? 62 : 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 34,
                  child: Text(
                    '#${index + 1}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: row.user.avatarColor,
                    ),
                    if (podiumIcon != null)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Icon(podiumIcon, size: 16, color: borderColor),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '@${row.user.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  _leaderboardMetricText(row),
                  style:
                      (isLeader
                              ? Theme.of(context).textTheme.titleMedium
                              : Theme.of(context).textTheme.bodyLarge)
                          ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardTableRow(_LeaderboardRow row, int index) {
    return InkWell(
      onTap: () => _openLeaderboardActions(row.user),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0x22000000))),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Text(
                '#${index + 1}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            CircleAvatar(radius: 12, backgroundColor: row.user.avatarColor),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                '@${row.user.username}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(_leaderboardMetricText(row)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardView(BuildContext context) {
    final rows = _leaderboardRows();
    final hasPendingFilterChanges =
        _draftPeriod != _appliedPeriod ||
        _draftSpot != _appliedSpot ||
        _draftScope != _appliedScope ||
        _draftOrder != _appliedOrder;

    final visibleCount = _visibleLeaderboardCount > rows.length
        ? rows.length
        : _visibleLeaderboardCount;
    final visibleRows = rows.take(visibleCount).toList();

    var myRank = -1;
    _CommunityUser? myUser;
    for (var i = 0; i < rows.length; i++) {
      if (rows[i].user.username == _myUsername) {
        myRank = i + 1;
        myUser = rows[i].user;
        break;
      }
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.xs,
              runSpacing: 6,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showLeaderboardFilters = !_showLeaderboardFilters;
                    });
                  },
                  icon: Icon(
                    _showLeaderboardFilters
                        ? Icons.expand_less_rounded
                        : Icons.tune_rounded,
                  ),
                  label: Text(
                    _showLeaderboardFilters
                        ? 'Ocultar filtros'
                        : 'Mostrar filtros',
                  ),
                ),
                FilledButton.icon(
                  onPressed: hasPendingFilterChanges ? _applyFilters : null,
                  icon: const Icon(Icons.filter_alt_rounded),
                  label: const Text('Aplicar filtros'),
                ),
              ],
            ),
            if (_showLeaderboardFilters) ...[
              const SizedBox(height: AppSpacing.xs),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 760;
                  final controls = [
                    _CommunityFilterField(
                      label: 'Periodo',
                      value: _draftPeriod,
                      values: const ['24h', '7d', '30d', 'All time'],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _draftPeriod = value);
                      },
                    ),
                    _CommunityFilterField(
                      label: 'Spot',
                      value: _draftSpot,
                      values: const [
                        'Todos',
                        'Tarifa',
                        'Fuerteventura',
                        'Gandia',
                        'Oliva Norte',
                        'El Medano',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _draftSpot = value);
                      },
                    ),
                    _CommunityFilterField(
                      label: 'Scope',
                      value: _draftScope,
                      values: const ['Global', 'Friends'],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _draftScope = value);
                      },
                    ),
                    _KpiOrderFilterField(
                      label: 'Orden',
                      value: _draftOrder,
                      options: _kpiOrderOptions,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _draftOrder = value);
                      },
                    ),
                  ];

                  if (isNarrow) {
                    return Column(
                      children: [
                        for (var i = 0; i < controls.length; i++) ...[
                          controls[i],
                          if (i != controls.length - 1)
                            const SizedBox(height: AppSpacing.xs),
                        ],
                      ],
                    );
                  }

                  return Row(
                    children: [
                      for (var i = 0; i < controls.length; i++) ...[
                        Expanded(child: controls[i]),
                        if (i != controls.length - 1)
                          const SizedBox(width: AppSpacing.xs),
                      ],
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Text(
              _leaderboardMetricHeader(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            if (rows.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text('No hay usuarios para los filtros actuales.'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  controller: _leaderboardScrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 56),
                  itemCount: visibleRows.length,
                  itemBuilder: (context, index) {
                    final row = visibleRows[index];
                    if (index < 5) {
                      return _buildLeaderboardCardRow(row, index);
                    }
                    return _buildLeaderboardTableRow(row, index);
                  },
                ),
              ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 10,
              ),
              color: Theme.of(context).colorScheme.surface,
              child: myRank == -1 || myUser == null
                  ? Text(
                      '-- · @$_myUsername · #-- / ${rows.length}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge,
                    )
                  : Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.xs,
                      runSpacing: 4,
                      children: [
                        Text('#$myRank'),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: myUser.avatarColor,
                        ),
                        Text('@${myUser.username}'),
                        Text('#$myRank / ${rows.length}'),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFollowingView(BuildContext context) {
    final friends = _followedUsers();
    final sessions = _followingSessions();

    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.group_rounded),
            title: const Text('Usuarios que sigues'),
            subtitle: Text('${friends.length} amigos'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: _openFriendsDirectory,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Sesiones de amigos',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (sessions.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Todavia no sigues a nadie. Abre el listado de amigos para buscar perfiles.',
              ),
            ),
          )
        else
          ...sessions.map((session) {
            final user = _users.firstWhere(
              (u) => u.username == session.username,
              orElse: () => const _CommunityUser(
                username: 'unknown',
                bigAirScore: 0,
                highestJumpMeters: 0,
                mainSpot: '',
                avatarColor: Colors.blueGrey,
              ),
            );

            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openFriendSessionDetail(session),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: session.hasSessionPhoto
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF90CAF9),
                                    Color(0xFF42A5F5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFFC8E6C9),
                                    Color(0xFF80CBC4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                session.hasSessionPhoto
                                    ? Icons.photo_camera_back_rounded
                                    : Icons.map_rounded,
                                size: 28,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                session.hasSessionPhoto
                                    ? 'Foto de la sesion'
                                    : 'Pantallazo del mapa del spot',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: user.avatarColor,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              '@${session.username}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          Text(session.dateLabel),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Spot: ${session.spot}'),
                      Text(
                        'Salto mas alto: ${session.highestJumpMeters.toStringAsFixed(1)} m',
                      ),
                      Text(
                        'Distancia: ${session.distanceKm.toStringAsFixed(1)} km',
                      ),
                      Text('Duracion: ${session.durationLabel}'),
                      Text('Equipo: ${session.equipmentLabel}'),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Text('${session.likesCount} likes'),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            tooltip: 'Dar like',
                            icon: const Icon(Icons.favorite_border_rounded),
                          ),
                          IconButton(
                            onPressed: () {},
                            tooltip: 'Comentar',
                            icon: const Icon(Icons.mode_comment_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Toca la tarjeta para ver el detalle completo de la sesion.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _NoStretchScrollBehavior(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              0,
            ),
            child: SegmentedButton<_CommunityTab>(
              segments: const [
                ButtonSegment<_CommunityTab>(
                  value: _CommunityTab.leaderboard,
                  label: Text('Leaderboard'),
                ),
                ButtonSegment<_CommunityTab>(
                  value: _CommunityTab.following,
                  label: Text('Amigos'),
                ),
              ],
              selected: {_selectedTab},
              onSelectionChanged: (value) {
                setState(() {
                  _selectedTab = value.first;
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: _selectedTab == _CommunityTab.leaderboard
                      ? _buildLeaderboardView(context)
                      : _buildFollowingView(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

enum _CommunityTab { leaderboard, following }

class _CommunityUser {
  const _CommunityUser({
    required this.username,
    required this.bigAirScore,
    required this.highestJumpMeters,
    required this.mainSpot,
    required this.avatarColor,
  });

  final String username;
  final int bigAirScore;
  final double highestJumpMeters;
  final String mainSpot;
  final Color avatarColor;
}

class _FollowingSession {
  const _FollowingSession({
    required this.username,
    required this.title,
    required this.spot,
    required this.dateLabel,
    required this.endedAt,
    required this.bigAirScore,
    required this.highestJumpMeters,
    required this.distanceKm,
    required this.durationLabel,
    required this.equipmentLabel,
    required this.likesCount,
    required this.hasSessionPhoto,
  });

  final String username;
  final String title;
  final String spot;
  final String dateLabel;
  final DateTime endedAt;
  final int bigAirScore;
  final double highestJumpMeters;
  final double distanceKm;
  final String durationLabel;
  final String equipmentLabel;
  final int likesCount;
  final bool hasSessionPhoto;
}

class _LeaderboardRow {
  const _LeaderboardRow({required this.user, required this.score});

  final _CommunityUser user;
  final int score;
}

class _CommunityFilterField extends StatelessWidget {
  const _CommunityFilterField({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: values
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _KpiFilterOption {
  const _KpiFilterOption.metric(this.key, this.label, this.unit)
    : isGroup = false,
      isDivider = false;

  const _KpiFilterOption.group(this.label)
    : key = null,
      unit = '',
      isGroup = true,
      isDivider = false;

  const _KpiFilterOption.divider()
    : key = null,
      label = '',
      unit = '',
      isGroup = false,
      isDivider = true;

  final String? key;
  final String label;
  final String unit;
  final bool isGroup;
  final bool isDivider;
}

class _KpiOrderFilterField extends StatelessWidget {
  const _KpiOrderFilterField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<_KpiFilterOption> options;
  final ValueChanged<String?> onChanged;

  Color _groupItemColor(String groupLabel) {
    switch (groupLabel) {
      case 'Core Session':
        return const Color(0xFFE3F2FD);
      case 'Big Air':
        return const Color(0xFFFFF8E1);
      case 'Freestyle':
        return const Color(0xFFF3E5F5);
      case 'Freeride / Navegacion':
        return const Color(0xFFE8F5E9);
      case 'Saltos':
        return const Color(0xFFFFF3E0);
      case 'Control tecnico':
        return const Color(0xFFE0F7FA);
      case 'Condiciones meteo-contexto':
        return const Color(0xFFE8EAF6);
      case 'Seguridad y riesgo':
        return const Color(0xFFFFEBEE);
      case 'Dispositivo y calidad de datos':
        return const Color(0xFFEDE7F6);
      case 'KPIs compuestos':
        return const Color(0xFFE0F2F1);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _groupHeaderColor(String groupLabel) {
    switch (groupLabel) {
      case 'Core Session':
        return const Color(0xFFBBDEFB);
      case 'Big Air':
        return const Color(0xFFFFE082);
      case 'Freestyle':
        return const Color(0xFFE1BEE7);
      case 'Freeride / Navegacion':
        return const Color(0xFFC8E6C9);
      case 'Saltos':
        return const Color(0xFFFFCC80);
      case 'Control tecnico':
        return const Color(0xFFB2EBF2);
      case 'Condiciones meteo-contexto':
        return const Color(0xFFC5CAE9);
      case 'Seguridad y riesgo':
        return const Color(0xFFFFCDD2);
      case 'Dispositivo y calidad de datos':
        return const Color(0xFFD1C4E9);
      case 'KPIs compuestos':
        return const Color(0xFFB2DFDB);
      default:
        return const Color(0xFFE0E0E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<String>>[];
    Color? activeGroupColor;

    for (var i = 0; i < options.length; i++) {
      final option = options[i];
      if (option.isDivider) {
        activeGroupColor = null;
        items.add(
          DropdownMenuItem<String>(
            value: '__divider_$i',
            enabled: false,
            child: const Divider(height: 1),
          ),
        );
        continue;
      }

      if (option.isGroup) {
        activeGroupColor = _groupItemColor(option.label);
        items.add(
          DropdownMenuItem<String>(
            value: '__group_$i',
            enabled: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _groupHeaderColor(option.label),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                option.label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
        continue;
      }

      items.add(
        DropdownMenuItem<String>(
          value: option.key,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: activeGroupColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(option.label, overflow: TextOverflow.ellipsis),
          ),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items,
      onChanged: (selected) {
        if (selected == null || selected.startsWith('__')) {
          return;
        }
        onChanged(selected);
      },
    );
  }
}

class _NoStretchScrollBehavior extends MaterialScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
