import 'package:supabase_flutter/supabase_flutter.dart';
import '../../rooms/domain/room.dart';

class BookingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createBooking({
    required Room room,
    required String guestName,
    required String guestPhone,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String paymentStatus, // 'Paid' or 'Unpaid'
    required String paymentMode,   // 'Cash' or 'Online'
  }) async {
    // 1. Calculate dates and amount
    final d1 = DateTime.utc(checkInDate.year, checkInDate.month, checkInDate.day);
    final d2 = DateTime.utc(checkOutDate.year, checkOutDate.month, checkOutDate.day);
    int days = d2.difference(d1).inDays;
    if (days <= 0) days = 1; // Minimum 1 day charge
    
    final double totalAmount = room.baseTariff * days;

    // 2. Perform transaction (RPC or direct depending on DB rules)
    // Supabase JS doesn't have native transaction blocks, but we can do sequential inserts 
    // or use a Postgres function. We'll do sequential here.
    
    // Create Guest or find existing by phone
    final existingGuestRes = await _supabase
        .from('guests')
        .select()
        .eq('phone_number', guestPhone)
        .limit(1)
        .maybeSingle();

    String guestId;
    if (existingGuestRes != null) {
      guestId = existingGuestRes['id'];
    } else {
      final newGuestRes = await _supabase
          .from('guests')
          .insert({
            'name': guestName,
            'phone_number': guestPhone,
          })
          .select()
          .single();
      guestId = newGuestRes['id'];
    }

    // Create Booking
    final bookingRes = await _supabase
        .from('bookings')
        .insert({
          'room_id': room.id,
          'guest_id': guestId,
          'check_in_date': checkInDate.toIso8601String().split('T')[0],
          'check_out_date': checkOutDate.toIso8601String().split('T')[0],
          'status': 'Reserved',
          'tariff_at_booking': room.baseTariff,
          'total_amount': totalAmount,
          'payment_status': paymentStatus,
          'created_by': _supabase.auth.currentUser!.id,
        })
        .select()
        .single();

    // If Paid, automatically create Payment Transaction
    if (paymentStatus == 'Paid') {
      await _supabase.from('payment_transactions').insert({
        'booking_id': bookingRes['id'],
        'amount': totalAmount,
        'payment_date': DateTime.now().toIso8601String().split('T')[0],
        'payment_mode': paymentMode,
        'recorded_by': _supabase.auth.currentUser!.id,
      });
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await _supabase.from('bookings').update({'status': newStatus}).eq('id', bookingId);
    
    // Audit trigger handles history in DB automatically, but we can also insert to booking_status_history
    await _supabase.from('booking_status_history').insert({
      'booking_id': bookingId,
      'new_status': newStatus,
      'changed_by': _supabase.auth.currentUser!.id,
    });
  }

  Future<void> recordPayment(String bookingId, double amount, String mode) async {
    await _supabase.from('payment_transactions').insert({
      'booking_id': bookingId,
      'amount': amount,
      'payment_mode': mode,
      'recorded_by': _supabase.auth.currentUser!.id,
    });
    
    await _supabase.from('bookings').update({'payment_status': 'Paid'}).eq('id', bookingId);
  }
}
