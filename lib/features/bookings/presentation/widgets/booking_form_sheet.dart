import 'package:flutter/material.dart';
import '../../../rooms/domain/room.dart';
import '../../services/booking_service.dart';
import 'package:intl/intl.dart';

class BookingFormSheet extends StatefulWidget {
  final Room room;
  final VoidCallback onBookingComplete;

  const BookingFormSheet({
    super.key,
    required this.room,
    required this.onBookingComplete,
  });

  @override
  State<BookingFormSheet> createState() => _BookingFormSheetState();
}

class _BookingFormSheetState extends State<BookingFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tariffController = TextEditingController();
  final _amountPaidController = TextEditingController();
  
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  String _paymentStatus = 'Unpaid';
  String _paymentMode = 'Cash';

  bool _isConfirming = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(const Duration(days: 1));
    _tariffController.text = widget.room.baseTariff.toInt().toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _tariffController.dispose();
    _amountPaidController.dispose();
    super.dispose();
  }

  int get _nights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final d1 = DateTime.utc(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
    final d2 = DateTime.utc(_checkOutDate!.year, _checkOutDate!.month, _checkOutDate!.day);
    int nights = d2.difference(d1).inDays;
    return nights <= 0 ? 1 : nights;
  }

  double get _currentTariff => double.tryParse(_tariffController.text) ?? widget.room.baseTariff;

  double get _totalAmount {
    return _currentTariff * _nights;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime initialDate = isCheckIn ? (_checkInDate ?? DateTime.now()) : (_checkOutDate ?? DateTime.now().add(const Duration(days: 1)));
    final DateTime firstDate = isCheckIn ? DateTime.now() : (_checkInDate ?? DateTime.now());
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(_checkInDate!)) {
            _checkOutDate = _checkInDate!.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await BookingService().createBooking(
        room: widget.room,
        guestName: _nameController.text,
        guestPhone: _phoneController.text,
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        paymentStatus: _paymentStatus,
        paymentMode: _paymentMode,
        overriddenTariff: _currentTariff,
        partialAmountPaid: double.tryParse(_amountPaidController.text),
      );
      widget.onBookingComplete();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('Booking Save Error: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isConfirming) return _buildConfirmation();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Book Room ${widget.room.roomNumber}', style: Theme.of(context).textTheme.titleLarge),
              if (widget.room.category != 'Hall')
                Text('Tariff: ₹${widget.room.baseTariff}/night', style: Theme.of(context).textTheme.bodyMedium),
              if (widget.room.category == 'Hall')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _tariffController,
                    decoration: const InputDecoration(labelText: 'Custom Tariff/Night', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Guest Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Check-in', border: OutlineInputBorder()),
                        child: Text(_checkInDate != null ? DateFormat('MMM dd, yyyy').format(_checkInDate!) : ''),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Check-out', border: OutlineInputBorder()),
                        child: Text(_checkOutDate != null ? DateFormat('MMM dd, yyyy').format(_checkOutDate!) : ''),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total ($_nights nights):', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹$_totalAmount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _paymentStatus,
                      decoration: const InputDecoration(labelText: 'Payment', border: OutlineInputBorder()),
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
              if (_paymentStatus == 'Partial') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountPaidController,
                  decoration: const InputDecoration(labelText: 'Amount Paid Now', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (v) => _paymentStatus == 'Partial' && (v == null || v.isEmpty) ? 'Required' : null,
                ),
              ],
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _nights > 0) {
                    setState(() => _isConfirming = true);
                  }
                },
                child: const Text('Review Booking'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmation() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Confirm Booking', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            _ConfirmRow('Room', widget.room.roomNumber),
            _ConfirmRow('Guest', _nameController.text),
            _ConfirmRow('Phone', _phoneController.text),
            _ConfirmRow('Check-in', DateFormat('MMM dd, yyyy').format(_checkInDate!)),
            _ConfirmRow('Check-out', DateFormat('MMM dd, yyyy').format(_checkOutDate!)),
            _ConfirmRow('Duration', '$_nights Nights'),
            _ConfirmRow('Tariff/Night', '₹$_currentTariff'),
            const Divider(),
            _ConfirmRow('Total Amount', '₹$_totalAmount', isBold: true),
            _ConfirmRow('Payment', '$_paymentStatus${(_paymentStatus == 'Paid' || _paymentStatus == 'Partial') ? ' via $_paymentMode' : ''}', 
              color: _paymentStatus == 'Paid' ? Colors.green : (_paymentStatus == 'Partial' ? Colors.orange : Colors.red)),
            if (_paymentStatus == 'Partial')
              _ConfirmRow('Amount Paid', '₹${_amountPaidController.text}', color: Colors.orange, isBold: true),
            
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : () => setState(() => _isConfirming = false),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting ? const CircularProgressIndicator() : const Text('Confirm & Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const _ConfirmRow(this.label, this.value, {this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }
}
