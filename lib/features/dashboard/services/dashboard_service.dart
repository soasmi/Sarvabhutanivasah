import 'package:supabase_flutter/supabase_flutter.dart';
import '../presentation/providers/dashboard_providers.dart';

class DashboardStats {
  final int totalRooms;
  final int availableRooms;
  final int reservedRooms;
  final int occupiedRooms;

  final int b1TotalRooms;
  final int b1BookedRooms;
  final double b1CashRevenue;
  final double b1OnlineRevenue;

  final int b2TotalRooms;
  final int b2BookedRooms;
  final double b2CashRevenue;
  final double b2OnlineRevenue;

  final int todaysCheckIns;
  final int todaysCheckOuts;

  final double totalCashRevenue;
  final double totalOnlineRevenue;
  final double totalRevenueReceived;
  final double expensesInCash;

  final List<Map<String, dynamic>> activeBookingsList;

  DashboardStats({
    required this.totalRooms,
    required this.availableRooms,
    required this.reservedRooms,
    required this.occupiedRooms,
    required this.b1TotalRooms,
    required this.b1BookedRooms,
    required this.b1CashRevenue,
    required this.b1OnlineRevenue,
    required this.b2TotalRooms,
    required this.b2BookedRooms,
    required this.b2CashRevenue,
    required this.b2OnlineRevenue,
    required this.todaysCheckIns,
    required this.todaysCheckOuts,
    required this.totalCashRevenue,
    required this.totalOnlineRevenue,
    required this.totalRevenueReceived,
    required this.expensesInCash,
    required this.activeBookingsList,
  });
}

class DashboardService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<DashboardStats> fetchStats(DashboardViewType viewType) async {
    final now = DateTime.now();
    final todayStr = now.toIso8601String().split('T')[0];

    String startDateStr = todayStr;
    String endDateStr = todayStr;

    if (viewType == DashboardViewType.monthly) {
      startDateStr = DateTime(now.year, now.month, 1).toIso8601String().split('T')[0];
      endDateStr = DateTime(now.year, now.month + 1, 0).toIso8601String().split('T')[0];
    } else if (viewType == DashboardViewType.yearly) {
      startDateStr = DateTime(now.year, 1, 1).toIso8601String().split('T')[0];
      endDateStr = DateTime(now.year, 12, 31).toIso8601String().split('T')[0];
    }

    // Map rooms to buildings
    final buildingsRes = await _supabase.from('buildings').select();
    final floorsRes = await _supabase.from('floors').select();
    final roomsRes = await _supabase.from('rooms').select();

    final Map<String, String> floorIdToBuildingName = {};
    for (var f in floorsRes as List) {
      Map<String, dynamic>? b;
      for (var building in buildingsRes as List) {
        if (building['id'] == f['building_id']) {
          b = building as Map<String, dynamic>;
          break;
        }
      }
      if (b != null) floorIdToBuildingName[f['id']] = b['name'];
    }

    final Map<String, String> roomIdToBuildingName = {};
    int totalRooms = 0, b1TotalRooms = 0, b2TotalRooms = 0;

    for (var r in roomsRes as List) {
      final bName = floorIdToBuildingName[r['floor_id']] ?? 'Unknown';
      roomIdToBuildingName[r['id']] = bName;
      totalRooms++;
      if (bName == 'Building 1') b1TotalRooms++;
      if (bName == 'Building 2') b2TotalRooms++;
    }

    // Fetch Active Bookings
    final activeBookingsRes = await _supabase
        .from('bookings')
        .select('*, rooms!inner(room_number), guests!inner(name)')
        .lte('check_in_date', todayStr)
        .gte('check_out_date', todayStr)
        .neq('status', 'Cancelled')
        .neq('status', 'Completed');

    int reservedRooms = 0, occupiedRooms = 0;
    int b1Booked = 0, b2Booked = 0;

    for (var b in activeBookingsRes as List) {
      final status = b['status'];
      final bName = roomIdToBuildingName[b['room_id']];

      if (status == 'Reserved') reservedRooms++;
      if (status == 'Checked-In') occupiedRooms++;

      if (status == 'Reserved' || status == 'Checked-In') {
        if (bName == 'Building 1') b1Booked++;
        if (bName == 'Building 2') b2Booked++;
      }
    }

    final availableRooms = totalRooms - reservedRooms - occupiedRooms;

    // Check-ins & Check-outs
    final checkInsRes = await _supabase.from('bookings').select().gte('check_in_date', startDateStr).lte('check_in_date', endDateStr).neq('status', 'Cancelled');
    final checkOutsRes = await _supabase.from('bookings').select().gte('check_out_date', startDateStr).lte('check_out_date', endDateStr).neq('status', 'Cancelled');

    // Revenue
    final paymentsRes = await _supabase
        .from('payment_transactions')
        .select('*, bookings!inner(room_id)')
        .gte('payment_date', startDateStr)
        .lte('payment_date', endDateStr);

    double b1Cash = 0, b1Online = 0;
    double b2Cash = 0, b2Online = 0;
    double totalCash = 0, totalOnline = 0;

    for (var p in paymentsRes as List) {
      final amount = double.parse(p['amount'].toString());
      final mode = p['payment_mode'];
      final roomId = p['bookings']['room_id'];
      final bName = roomIdToBuildingName[roomId];

      if (mode == 'Cash') {
        totalCash += amount;
        if (bName == 'Building 1') b1Cash += amount;
        if (bName == 'Building 2') b2Cash += amount;
      } else if (mode == 'Online') {
        totalOnline += amount;
        if (bName == 'Building 1') b1Online += amount;
        if (bName == 'Building 2') b2Online += amount;
      }
    }

    final totalRevenueReceived = totalCash + totalOnline;

    // Expenses in Cash
    final expensesRes = await _supabase
        .from('expenses')
        .select('amount')
        .eq('payment_mode', 'Cash')
        .gte('created_at', '${startDateStr}T00:00:00Z')
        .lte('created_at', '${endDateStr}T23:59:59Z');

    double expensesInCash = 0;
    for (var e in expensesRes as List) {
      expensesInCash += double.parse(e['amount'].toString());
    }

    return DashboardStats(
      totalRooms: totalRooms,
      availableRooms: availableRooms,
      reservedRooms: reservedRooms,
      occupiedRooms: occupiedRooms,
      b1TotalRooms: b1TotalRooms,
      b1BookedRooms: b1Booked,
      b1CashRevenue: b1Cash,
      b1OnlineRevenue: b1Online,
      b2TotalRooms: b2TotalRooms,
      b2BookedRooms: b2Booked,
      b2CashRevenue: b2Cash,
      b2OnlineRevenue: b2Online,
      todaysCheckIns: (checkInsRes as List).length,
      todaysCheckOuts: (checkOutsRes as List).length,
      totalCashRevenue: totalCash,
      totalOnlineRevenue: totalOnline,
      totalRevenueReceived: totalRevenueReceived,
      expensesInCash: expensesInCash,
      activeBookingsList: (activeBookingsRes as List).cast<Map<String, dynamic>>(),
    );
  }
}
