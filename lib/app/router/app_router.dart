import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokitev2_0/app/router/app_routes.dart';
import 'package:meteokitev2_0/core/config/env/env_config.dart';
import 'package:meteokitev2_0/features/auth/presentation/pages/login_page.dart';
import 'package:meteokitev2_0/features/dashboard/presentation/pages/dashboard_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: EnvConfig.devBypassEnabled
        ? AppRoutes.dashboard
        : AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  );
});
