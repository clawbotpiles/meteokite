import 'package:flutter/material.dart';

class CommunityUserSessionsPage extends StatelessWidget {
  const CommunityUserSessionsPage({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sesiones de usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@$username',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Placeholder de sesiones para la fase UI-first.'),
          ],
        ),
      ),
    );
  }
}
