import 'package:supabase_flutter/supabase_flutter.dart';

class ExpenseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final res = await _supabase
        .from('expenses')
        .select('*')
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<void> addExpense({
    required String payee,
    required String purpose,
    required double amount,
    required String paymentMode,
  }) async {
    await _supabase.from('expenses').insert({
      'payee': payee,
      'purpose': purpose,
      'amount': amount,
      'payment_mode': paymentMode,
      'created_by': _supabase.auth.currentUser!.id,
    });
  }
}
