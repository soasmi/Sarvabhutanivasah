import 'package:flutter/material.dart';
import '../../../bookings/services/booking_service.dart';

class PaymentFormSheet extends StatefulWidget {
  final String bookingId;
  final double totalAmount;
  final VoidCallback onPaymentComplete;

  const PaymentFormSheet({
    super.key,
    required this.bookingId,
    required this.totalAmount,
    required this.onPaymentComplete,
  });

  @override
  State<PaymentFormSheet> createState() => _PaymentFormSheetState();
}

class _PaymentFormSheetState extends State<PaymentFormSheet> {
  String _paymentStatus = 'Paid';
  String _paymentMode = 'Cash';
  bool _isSubmitting = false;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.totalAmount.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_paymentStatus == 'Unpaid') {
      Navigator.pop(context); // Nothing to do if they select Unpaid
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final amountPaid = double.tryParse(_amountController.text) ?? widget.totalAmount;
      await BookingService().recordPayment(
        widget.bookingId,
        amountPaid,
        _paymentMode,
      );
      widget.onPaymentComplete();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Record Payment', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Total Bill Amount: ₹${widget.totalAmount}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount Paying Now', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _paymentStatus,
                  decoration: const InputDecoration(labelText: 'Payment Status', border: OutlineInputBorder()),
                  items: ['Paid', 'Partial', 'Unpaid'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _paymentStatus = v!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _paymentMode,
                  decoration: const InputDecoration(labelText: 'Mode', border: OutlineInputBorder()),
                  items: ['Cash', 'Online'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (_paymentStatus == 'Paid' || _paymentStatus == 'Partial') ? (v) => setState(() => _paymentMode = v!) : null,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting ? const CircularProgressIndicator() : const Text('Confirm Payment'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
