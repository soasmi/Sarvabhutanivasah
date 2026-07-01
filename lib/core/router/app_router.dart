import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_state_provider.dart';
import '../../features/rooms/domain/building.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/rooms/presentation/rooms_screen.dart';
import '../../features/rooms/presentation/room_mapping_screen.dart';
import '../../features/expenses/presentation/expenses_screen.dart';
import '../../shared/widgets/coming_soon_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isSplashFinished = ref.watch(splashFinishedProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      // If splash is not finished, force splash screen
      if (!isSplashFinished) {
        return isSplash ? null : '/splash';
      }

      // We are fully loaded.
      final isAuthenticated = authState.user != null && authState.userRole != null;

      // Unauthenticated users must go to login
      if (!isAuthenticated) {
        if (isLoggingIn) return null;
        return '/login';
      }

      // Authenticated users shouldn't see login or splash
      if (isAuthenticated && (isLoggingIn || isSplash)) {
        return '/';
      }

      // Role-based protection: Only Managers can access Room Mapping
      final isMapping = state.matchedLocation == '/room-mapping';
      if (isMapping && authState.userRole != 'Manager') {
        return '/'; // Fallback to dashboard
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/rooms',
        builder: (context, state) => const RoomsScreen(),
      ),
      GoRoute(
        path: '/katyayani',
        builder: (context, state) => const ComingSoonScreen(
          title: 'Building 2',
          icon: Icons.domain,
          description: 'Building 2 functionality is currently under development.',
        ),
      ),
      GoRoute(
        path: '/room-mapping',
        builder: (context, state) {
          final building = state.extra as Building;
          return RoomMappingScreen(
            buildingId: building.id,
            svgAsset: building.svgAssetName,
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const ComingSoonScreen(
          title: 'Settings',
          icon: Icons.settings,
          description: 'System configuration and user management are currently under development. Here you will be able to configure tariffs, users, and app preferences.',
        ),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesScreen(),
      ),
    ],
  );
});
