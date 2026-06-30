import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/building.dart';
import '../../domain/room.dart';
import '../../../../core/constants/app_colors.dart';

// Provides the list of buildings
final buildingsProvider = FutureProvider<List<Building>>((ref) async {
  final response = await Supabase.instance.client.from('buildings').select().order('created_at');
  return (response as List).map((e) => Building.fromJson(e)).toList();
});

// Holds the currently selected building ID
final selectedBuildingIdProvider = StateProvider<String?>((ref) => null);

// A data class to hold the combined room status
class RoomStatusData {
  final Room room;
  final String status; // Available, Reserved, Checked-In, Maintenance
  final Map<String, dynamic>? currentBooking;

  RoomStatusData({
    required this.room,
    required this.status,
    this.currentBooking,
  });

  Color get color {
    switch (status) {
      case 'Reserved': return AppColors.statusReserved;
      case 'Checked-In': return AppColors.statusOccupied;
      case 'Maintenance': return AppColors.statusMaintenance;
      default: return AppColors.statusAvailable;
    }
  }
}

// Subscribes to realtime bookings to derive room statuses for a building
final _allRoomsProvider = FutureProvider<List<Room>>((ref) async {
  final res = await Supabase.instance.client.from('rooms').select();
  return (res as List).map((e) => Room.fromJson(e)).toList();
});

final currentBookingsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return Supabase.instance.client
      .from('bookings')
      .stream(primaryKey: ['id'])
      .order('created_at');
});

final roomsStatusProvider = Provider<AsyncValue<List<RoomStatusData>>>((ref) {
  final roomsAsync = ref.watch(_allRoomsProvider);
  final bookingsStream = ref.watch(currentBookingsStreamProvider);

  if (roomsAsync.isLoading || bookingsStream.isLoading) {
    return const AsyncLoading();
  }

  if (roomsAsync.hasError) return AsyncError(roomsAsync.error!, roomsAsync.stackTrace!);

  final rooms = roomsAsync.value ?? [];
  final bookings = bookingsStream.value ?? [];
  final today = DateTime.now();

  final statusList = rooms.map((room) {
    // Find an active booking for this room
    final activeBooking = bookings.cast<Map<String, dynamic>>().cast<Map<String, dynamic>?>().firstWhere(
      (b) {
        if (b == null) return false;
        if (b['room_id'] != room.id) return false;
        final status = b['status'];
        if (status == 'Completed' || status == 'Cancelled' || status == 'Checked-Out') return false;
        
        final checkIn = DateTime.parse(b['check_in_date']);
        final checkOut = DateTime.parse(b['check_out_date']);
        return today.isAfter(checkIn.subtract(const Duration(days: 1))) && today.isBefore(checkOut.add(const Duration(days: 1)));
      },
      orElse: () => null,
    );

    String derivedStatus = 'Available';
    if (activeBooking != null) {
      derivedStatus = activeBooking['status'] as String;
    }

    return RoomStatusData(
      room: room,
      status: derivedStatus,
      currentBooking: activeBooking,
    );
  }).toList();

  return AsyncValue.data(statusList);
});
