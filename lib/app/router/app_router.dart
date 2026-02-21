import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meteokite/app/router/app_routes.dart';
import 'package:meteokite/features/auth/presentation/pages/login_page.dart';
import 'package:meteokite/features/auth/presentation/pages/setup_profile_page.dart';
import 'package:meteokite/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:meteokite/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:meteokite/features/profile/presentation/pages/profile_page.dart';
import 'package:meteokite/features/sessions/presentation/pages/sessions_page.dart';
import 'package:meteokite/features/spots/social/presentation/pages/social_page.dart';
import 'package:meteokite/features/spots/stations/presentation/pages/stations_page.dart';
import 'package:meteokite/features/spots/weather/presentation/pages/weather_page.dart';

final _routerRefreshProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);

  ref.listen(authSessionProvider, (previous, next) {
    notifier.value++;
  });

  ref.onDispose(notifier.dispose);
  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authSessionProvider);
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.valueOrNull?.isAuthenticated ?? false;
      final hasCompletedProfile =
          authState.valueOrNull?.hasCompletedProfile ?? false;
      final isLoginRoute = state.matchedLocation == AppRoutes.authLogin;
      final isSetupProfileRoute =
          state.matchedLocation == AppRoutes.authSetupProfile;

      if (!isLoggedIn && !isLoginRoute) {
        return AppRoutes.authLogin;
      }

      if (isLoggedIn && !hasCompletedProfile && !isSetupProfileRoute) {
        return AppRoutes.authSetupProfile;
      }

      if (isLoggedIn &&
          hasCompletedProfile &&
          (isLoginRoute || isSetupProfileRoute)) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.authLogin,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.authSetupProfile,
        builder: (context, state) => const SetupProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.profileHome,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.sessionsHome,
        builder: (context, state) => const SessionsPage(),
      ),
      GoRoute(
        path: AppRoutes.spotsWeather,
        builder: (context, state) => const WeatherPage(),
      ),
      GoRoute(
        path: AppRoutes.spotsStations,
        builder: (context, state) => const StationsPage(),
      ),
      GoRoute(
        path: AppRoutes.spotsSocial,
        builder: (context, state) => const SocialPage(),
      ),
    ],
  );
});
