import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/rooms_state_provider.dart';
import '../../auth/presentation/auth_state_provider.dart';
import '../../bookings/services/booking_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../bookings/presentation/widgets/booking_form_sheet.dart';
import '../../payments/presentation/widgets/payment_form_sheet.dart';
import '../../../shared/widgets/app_drawer.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isManager = authState.userRole == 'Manager';

    final roomStatusesAsync = ref.watch(roomsStatusProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Gauri Sadan'),
      ),
      backgroundColor: AppColors.background,
      body: roomStatusesAsync.when(
        data: (roomStatuses) {
          if (roomStatuses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, size: 64, color: AppColors.accentGold),
                  const SizedBox(height: 16),
                  Text(
                    'No Rooms Found',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primaryButton),
                  ),
                  const SizedBox(height: 8),
                  const Text('Please ensure the database seed script has been executed to load Gauri Sadan.'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildLegend(),
                const SizedBox(height: 32),
                _buildGauriSadanMap(roomStatuses, isManager),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.white, 'Available'),
        const SizedBox(width: 16),
        _buildLegendItem(Colors.orange[100]!, 'Reserved'),
        const SizedBox(width: 16),
        _buildLegendItem(Colors.green[100]!, 'Occupied'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: AppColors.primaryButton),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryButton),
        ),
      ],
    );
  }

  Widget _buildGauriSadanMap(List<RoomStatusData> roomStatuses, bool isManager) {
    return Column(
      children: [
        // Second Floor
        _buildFloorSection(
          title: 'Second Floor',
          hindiTitle: 'द्वितीय तल',
          content: Column(
            children: [
              _buildRoomRow(['201', '202', '203', '204', '205', '206', '207', '208'], roomStatuses, isManager),
              const SizedBox(height: 16),
              _buildRoomRow(['209', '210', '211', '212', '213', '214', '215', '216'], roomStatuses, isManager),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // First Floor
        _buildFloorSection(
          title: 'First Floor',
          hindiTitle: 'प्रथम तल',
          content: Column(
            children: [
              _buildRoomRow(['101', '102', '103', '104', '105', '106', '107', '108'], roomStatuses, isManager),
              const SizedBox(height: 16),
              _buildRoomRow(['109', '110', '111', '112', '113', '114', '115', '116'], roomStatuses, isManager),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Ground Floor
        _buildFloorSection(
          title: 'Ground Floor',
          hindiTitle: 'भू तल',
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side rooms
              SizedBox(
                width: 150,
                child: Column(
                  children: [
                    _buildSingleRoom('G-1', roomStatuses, isManager),
                    const SizedBox(height: 8),
                    _buildSingleRoom('G-2', roomStatuses, isManager),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Center Hall
              Expanded(
                child: Container(
                  height: 208, // 100 + 100 + 8
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryButton, width: 2),
                    color: AppColors.surfaceSecondary.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: Text(
                      'Hall-1',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryButton,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Right side rooms (using G-3, G-4 based on logic)
              SizedBox(
                width: 150,
                child: Column(
                  children: [
                    _buildSingleRoom('G-3', roomStatuses, isManager),
                    const SizedBox(height: 8),
                    _buildSingleRoom('G-4', roomStatuses, isManager),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloorSection({required String title, required String hindiTitle, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryButton,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              hindiTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryButton,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.primaryButton, thickness: 2),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildRoomRow(List<String> roomNumbers, List<RoomStatusData> statuses, bool isManager) {
    return Row(
      children: roomNumbers.map((number) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _buildSingleRoom(number, statuses, isManager),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleRoom(String roomNumber, List<RoomStatusData> statuses, bool isManager) {
    // Find the room status
    final statusData = statuses.where((s) => s.room.roomNumber == roomNumber).firstOrNull;
    
    // Default values if room not found in DB
    final category = statusData?.room.category ?? (roomNumber.startsWith('G') ? '2 BED' : '6 BED');
    final tariff = statusData?.room.baseTariff ?? (roomNumber.startsWith('G') ? 1200.0 : 1500.0);
    final status = statusData?.status ?? 'Available';

    Color bgColor = Colors.white;
    if (status == 'Reserved') bgColor = Colors.orange[100]!;
    if (status == 'Occupied' || status == 'Checked-In') bgColor = Colors.green[100]!;

    return InkWell(
      onTap: () {
        if (statusData != null) {
          _showRoomDetailsSheet(context, statusData, isManager);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Room not initialized in database.')),
          );
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: AppColors.primaryButton, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              roomNumber,
              style: const TextStyle(
                color: AppColors.primaryButton,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '₹${tariff.toInt()}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoomDetailsSheet(BuildContext context, RoomStatusData data, bool isManager) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room ${data.room.roomNumber}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryButton,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(data.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _getStatusColor(data.status)),
                      ),
                      child: Text(
                        data.status,
                        style: TextStyle(
                          color: _getStatusColor(data.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.room.category} • ₹${data.room.baseTariff.toStringAsFixed(2)} / night',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Divider(height: 32),
                
                if (data.status != 'Available' && data.currentBooking != null) ...[
                  Text(
                    'Booked for ${data.currentBooking!['guests']?['name'] ?? 'Unknown'}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.currentBooking!['guests']?['phone_number'] ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check-in', style: Theme.of(context).textTheme.titleSmall),
                            Text(data.currentBooking!['check_in_date'].toString().split(' ')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check-out', style: Theme.of(context).textTheme.titleSmall),
                            Text(data.currentBooking!['check_out_date'].toString().split(' ')[0]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Payment Status: ${data.currentBooking!['payment_status']}',
                      style: TextStyle(
                        color: data.currentBooking!['payment_status'] == 'Paid' ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                ] else ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Text('This room is currently available for booking.'),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                if (isManager) ...[
                  if (data.status == 'Available')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => BookingFormSheet(
                            room: data.room,
                            onBookingComplete: () {},
                          ),
                        );
                      },
                      child: const Text('Book Room'),
                    ),
                  if (data.status != 'Available' && data.currentBooking != null && data.currentBooking!['payment_status'] != 'Paid')
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => PaymentFormSheet(
                            bookingId: data.currentBooking!['id'],
                            totalAmount: double.parse(data.currentBooking!['total_amount'].toString()),
                            onPaymentComplete: () {},
                          ),
                        );
                      }, 
                      child: const Text('Record Payment')
                    ),
                  const SizedBox(height: 8),
                  if (data.status == 'Reserved')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () async {
                        try {
                          await BookingService().updateBookingStatus(data.currentBooking!['id'], 'Checked-In');
                          if (context.mounted) Navigator.pop(context);
                        } catch(e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        }
                      },
                      child: const Text('Mark as Checked-In (Occupied)'),
                    ),
                  const SizedBox(height: 8),
                  if (data.status == 'Checked-In')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        try {
                          await BookingService().updateBookingStatus(data.currentBooking!['id'], 'Completed');
                          if (context.mounted) Navigator.pop(context);
                        } catch(e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        }
                      },
                      child: const Text('Check Out'),
                    ),
                ] else ...[
                  const Center(child: Text('View Only Access', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Reserved':
        return Colors.orange;
      case 'Occupied':
      case 'Checked-In':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
