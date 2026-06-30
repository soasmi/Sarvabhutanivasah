import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/dashboard_service.dart';

// Enum for Dashboard View Type
enum DashboardViewType { daily, monthly, yearly }

final dashboardViewTypeProvider = StateProvider<DashboardViewType>((ref) => DashboardViewType.daily);

final dashboardLastUpdatedProvider = StateProvider<DateTime>((ref) => DateTime.now());

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) async* {
  final supabase = Supabase.instance.client;
  final viewType = ref.watch(dashboardViewTypeProvider);
  final service = DashboardService();

  // Initial fetch
  yield await service.fetchStats(viewType);
  ref.read(dashboardLastUpdatedProvider.notifier).state = DateTime.now();

  // Create a combined stream for bookings and payments
  final bookingsStream = supabase.from('bookings').stream(primaryKey: ['id']);
  // final paymentsStream = supabase.from('payment_transactions').stream(primaryKey: ['id']);

  // We use a simple approach: any change in bookings or payments triggers a re-fetch of stats
  // We can yield the updated stats whenever a stream emits.
  await for (final _ in bookingsStream) {
    yield await service.fetchStats(viewType);
    ref.read(dashboardLastUpdatedProvider.notifier).state = DateTime.now();
  }
  
  // Note: To properly listen to both concurrently in a robust way, we might need RxDart's Rx.merge 
  // or just depend on bookings for now (as payments are linked to bookings).
});
