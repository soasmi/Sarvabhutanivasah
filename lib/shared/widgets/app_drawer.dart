import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_state_provider.dart';
import '../../core/constants/app_colors.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final role = authState.userRole ?? 'Loading...';
    
    // Helper for creating list tiles with consistent styling
    Widget buildDrawerItem({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
      bool isDestructive = false,
    }) {
      return ListTile(
        leading: Icon(
          icon, 
          color: isDestructive ? AppColors.error : AppColors.primaryButton
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // close drawer
          onTap();
        },
      );
    }

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryButton,
            ),
            accountName: Text(
              user?.email ?? 'Unknown User',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            accountEmail: Text(
              'Role: $role',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.surfaceSecondary),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppColors.surfaceSecondary,
              child: Icon(Icons.person, color: AppColors.primaryButton, size: 40),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () => context.go('/'),
                ),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: const Icon(Icons.book_online, color: AppColors.primaryButton),
                    title: const Text('Booking', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 72, right: 16),
                        title: const Text('Gauri Sadan', style: TextStyle(color: AppColors.textPrimary)),
                        onTap: () => context.go('/rooms'),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 72, right: 16),
                        title: const Text('Katyayani Sadan', style: TextStyle(color: AppColors.textPrimary)),
                        onTap: () => context.go('/katyayani'),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
          const Divider(),
          buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            isDestructive: true,
            onTap: () => ref.read(authStateProvider.notifier).logout(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
