import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import 'shared/shared_widgets.dart';

/// Vehicle Info Card Widget
/// Displays vehicle details (plate number, make, model, color)
class VehicleInfoCard extends StatelessWidget {
  final BookingModel booking;

  const VehicleInfoCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = booking.vehicle;
    if (vehicle == null) {
      return const SizedBox.shrink();
    }

    return InfoCard(
      child: VehicleDisplayWidget(
        vehicle: vehicle,
        showIcon: true,
        showMakeModel: true,
        showPlateNumber: true,
        compact: false,
      ),
    );
  }
}



