import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'providers/dashboard_providers.dart';
import '../services/dashboard_service.dart';

import '../../../shared/widgets/app_drawer.dart';
import '../../../core/constants/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final viewType = ref.watch(dashboardViewTypeProvider);
    final lastUpdated = ref.watch(dashboardLastUpdatedProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.activeState1,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sync, size: 14, color: AppColors.accentGold),
                    const SizedBox(width: 6),
                    Text(
                      'Updated: ${DateFormat.jm().format(lastUpdated)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.surfaceSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<DashboardViewType>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return AppColors.primaryButton;
                  return AppColors.surfaceSecondary;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) return Colors.white;
                  return AppColors.primaryButton;
                }),
                side: const WidgetStatePropertyAll(BorderSide(color: AppColors.primaryButton)),
              ),
              segments: const [
                ButtonSegment(value: DashboardViewType.daily, label: Text('Daily')),
                ButtonSegment(value: DashboardViewType.monthly, label: Text('Monthly')),
                ButtonSegment(value: DashboardViewType.yearly, label: Text('Yearly')),
              ],
              selected: {viewType},
              onSelectionChanged: (Set<DashboardViewType> newSelection) {
                ref.read(dashboardViewTypeProvider.notifier).state = newSelection.first;
              },
            ),
          ),
          Expanded(
            child: statsAsync.when(
              data: (stats) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildOccupancyByTariffCards(stats, context),
                    const SizedBox(height: 24),
                    _buildRevenueCard(stats, context, viewType),
                    const SizedBox(height: 32),
                    _buildActiveBookingsList(stats, context),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyByTariffCards(DashboardStats stats, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildTariffCard(
              context: context,
              title: '₹1200 Rooms',
              booked: stats.booked1200Rooms,
              total: stats.total1200Rooms,
              color: AppColors.accentGold,
              width: cardWidth,
            ),
            _buildTariffCard(
              context: context,
              title: '₹1500 Rooms',
              booked: stats.booked1500Rooms,
              total: stats.total1500Rooms,
              color: AppColors.primaryButton,
              width: cardWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTariffCard({
    required BuildContext context,
    required String title,
    required int booked,
    required int total,
    required Color color,
    required double width,
  }) {
    final double percentage = total == 0 ? 0 : (booked / total);
    return SizedBox(
      width: width,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
                  Icon(Icons.bed, color: color, size: 32),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Occupied', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text('$booked / $total', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text('${(percentage * 100).toStringAsFixed(0)}%', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 12,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueCard(DashboardStats stats, BuildContext context, DashboardViewType viewType) {
    String labelSuffix = viewType == DashboardViewType.daily ? 'Today' : viewType == DashboardViewType.monthly ? 'This Month' : 'This Year';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: AppColors.accentGold, size: 32),
                const SizedBox(width: 12),
                Text('Revenue $labelSuffix', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text('Total Collections', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text('₹${stats.revenueReceived.toStringAsFixed(0)}', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _buildRevenueTypeIndicator(
                    context: context,
                    title: 'Cash',
                    amount: stats.cashRevenue,
                    total: stats.revenueReceived,
                    color: Colors.green,
                    icon: Icons.payments,
                  ),
                ),
                Container(width: 1, height: 60, color: AppColors.divider, margin: const EdgeInsets.symmetric(horizontal: 16)),
                Expanded(
                  child: _buildRevenueTypeIndicator(
                    context: context,
                    title: 'Online',
                    amount: stats.onlineRevenue,
                    total: stats.revenueReceived,
                    color: Colors.blue,
                    icon: Icons.qr_code,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTypeIndicator({
    required BuildContext context,
    required String title,
    required double amount,
    required double total,
    required Color color,
    required IconData icon,
  }) {
    final percentage = total == 0 ? 0.0 : (amount / total);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 8),
        Text('₹${amount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('${(percentage * 100).toStringAsFixed(0)}%', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildActiveBookingsList(DashboardStats stats, BuildContext context) {
    if (stats.activeBookingsList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Active Bookings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.primaryButton,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(color: AppColors.primaryButton, thickness: 2),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shadowColor: AppColors.primaryButton.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider, width: 1),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.activeBookingsList.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final booking = stats.activeBookingsList[index];
              final roomNumber = booking['rooms']?['room_number'] ?? 'Unknown';
              final guestName = booking['guests']?['name'] ?? 'Unknown';
              final checkIn = booking['check_in_date'].toString().split(' ')[0];
              final checkOut = booking['check_out_date'].toString().split(' ')[0];
              final status = booking['status'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: status == 'Checked-In' ? Colors.green[100] : Colors.orange[100],
                  child: Text(
                    roomNumber,
                    style: TextStyle(
                      color: status == 'Checked-In' ? Colors.green[800] : Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                title: Text(
                  guestName,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                subtitle: Text('Check-in: $checkIn  •  Check-out: $checkOut'),
                trailing: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Checked-In' ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
