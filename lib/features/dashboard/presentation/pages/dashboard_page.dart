import 'package:flutter/material.dart';
import 'package:meteokitev2_0/features/community/presentation/pages/community_page.dart';
import 'package:meteokitev2_0/features/profile/presentation/pages/profile_page.dart';
import 'package:meteokitev2_0/features/sessions/presentation/pages/sessions_page.dart';
import 'package:meteokitev2_0/features/spots/presentation/pages/spots_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final GlobalKey<SpotsPageState> _spotsKey = GlobalKey<SpotsPageState>();

  List<Widget> get _pages => [
    SpotsPage(key: _spotsKey),
    const SessionsPage(),
    const CommunityPage(),
    const ProfilePage(),
  ];

  Future<void> _handleSpotsToolbarAction(_SpotsToolbarAction action) async {
    final state = _spotsKey.currentState;
    if (state == null) {
      return;
    }

    switch (action) {
      case _SpotsToolbarAction.edit:
        state.editSpotFromToolbar();
      case _SpotsToolbarAction.delete:
        state.deleteMultipleSpotsFromToolbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MeteoKite'),
        actions: [
          if (_selectedIndex == 0)
            PopupMenuButton<_SpotsToolbarAction>(
              onSelected: _handleSpotsToolbarAction,
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _SpotsToolbarAction.edit,
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: _SpotsToolbarAction.delete,
                  child: Text('Eliminar'),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.place_outlined),
            selectedIcon: Icon(Icons.place),
            label: 'Spots',
          ),
          NavigationDestination(
            icon: Icon(Icons.surfing_outlined),
            selectedIcon: Icon(Icons.surfing),
            label: 'Session',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

enum _SpotsToolbarAction { edit, delete }
