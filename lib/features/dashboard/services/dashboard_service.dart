import 'package:supabase_flutter/supabase_flutter.dart';
import '../presentation/providers/dashboard_providers.dart';

class DashboardStats {
  final int totalRooms;
  final int availableRooms;
  final int reservedRooms;
  final int occupiedRooms;
  
  final int total1200Rooms;
  final int booked1200Rooms;
  
  final int total1500Rooms;
  final int booked1500Rooms;
  
  final int todaysCheckIns;
  final int todaysCheckOuts;
  
  final double revenueReceived;
  final double cashRevenue;
  final double onlineRevenue;
  
  final List<Map<String, dynamic>> activeBookingsList;
  
  DashboardStats({
    required this.totalRooms,
    required this.availableRooms,
    required this.reservedRooms,
    required this.occupiedRooms,
    required this.total1200Rooms,
    required this.booked1200Rooms,
    required this.total1500Rooms,
    required this.booked1500Rooms,
    required this.todaysCheckIns,
    required this.todaysCheckOuts,
    required this.revenueReceived,
    required this.cashRevenue,
    required this.onlineRevenue,
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

    // 1. Fetch Rooms Count & Tariffs
    final roomsRes = await _supabase.from('rooms').select('id, base_tariff');
    final roomsList = roomsRes as List;
    final int totalRooms = roomsList.length;
    
    int total1200 = 0;
    int total1500 = 0;
    for (var r in roomsList) {
      if (r['base_tariff'] == 1200 || r['base_tariff'] == 1200.0) total1200++;
      if (r['base_tariff'] == 1500 || r['base_tariff'] == 1500.0) total1500++;
    }

    // 2. Fetch Active Bookings for Occupancy logic
    final activeBookingsRes = await _supabase
        .from('bookings')
        .select('*, rooms!inner(base_tariff, room_number), guests!inner(name)')
        .lte('check_in_date', todayStr)
        .gte('check_out_date', todayStr)
        .neq('status', 'Cancelled')
        .neq('status', 'Completed');

    int reservedRooms = 0;
    int occupiedRooms = 0;
    int booked1200 = 0;
    int booked1500 = 0;

    for (var b in activeBookingsRes as List) {
      final status = b['status'];
      final tariff = b['rooms']['base_tariff'];
      
      if (status == 'Reserved') reservedRooms++;
      if (status == 'Checked-In') occupiedRooms++;
      
      if (status == 'Reserved' || status == 'Checked-In') {
        if (tariff == 1200 || tariff == 1200.0) booked1200++;
        if (tariff == 1500 || tariff == 1500.0) booked1500++;
      }
    }

    final availableRooms = totalRooms - reservedRooms - occupiedRooms;

    // 3. Fetch Check-ins & Check-outs within the viewType date range
    final checkInsRes = await _supabase
        .from('bookings')
        .select()
        .gte('check_in_date', startDateStr)
        .lte('check_in_date', endDateStr)
        .neq('status', 'Cancelled');
        
    final checkOutsRes = await _supabase
        .from('bookings')
        .select()
        .gte('check_out_date', startDateStr)
        .lte('check_out_date', endDateStr)
        .neq('status', 'Cancelled');

    // 4. Fetch Revenue Received within the viewType date range
    final paymentsRes = await _supabase
        .from('payment_transactions')
        .select()
        .gte('payment_date', startDateStr)
        .lte('payment_date', endDateStr);

    double cashRevenue = 0;
    double onlineRevenue = 0;

    for (var p in paymentsRes as List) {
      final amount = double.parse(p['amount'].toString());
      if (p['payment_mode'] == 'Cash') {
        cashRevenue += amount;
      } else if (p['payment_mode'] == 'Online') {
        onlineRevenue += amount;
      }
    }

    return DashboardStats(
      totalRooms: totalRooms,
      availableRooms: availableRooms,
      reservedRooms: reservedRooms,
      occupiedRooms: occupiedRooms,
      total1200Rooms: total1200,
      booked1200Rooms: booked1200,
      total1500Rooms: total1500,
      booked1500Rooms: booked1500,
      todaysCheckIns: (checkInsRes as List).length,
      todaysCheckOuts: (checkOutsRes as List).length,
      revenueReceived: cashRevenue + onlineRevenue,
      cashRevenue: cashRevenue,
      onlineRevenue: onlineRevenue,
      activeBookingsList: (activeBookingsRes as List).cast<Map<String, dynamic>>(),
    );
  }
}
