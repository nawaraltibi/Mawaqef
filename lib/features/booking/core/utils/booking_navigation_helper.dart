import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../parking/models/parking_model.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../models/create_booking_response.dart';

/// Booking Navigation Helper
/// Centralizes navigation logic for booking flows
/// 
/// Separates navigation concerns from UI screens
class BookingNavigationHelper {
  /// Navigate to payment screen after booking creation
  static void navigateToPayment({
    required BuildContext context,
    required ParkingModel parking,
    required VehicleModel vehicle,
    required int hours,
    required double totalAmount,
    required int bookingId,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    context.push(
      Routes.paymentPath,
      extra: {
        'parking': parking,
        'vehicle': vehicle,
        'hours': hours,
        'totalAmount': totalAmount,
        'bookingId': bookingId,
        if (startTime != null) 'startTime': startTime,
        if (endTime != null) 'endTime': endTime,
      },
    );
  }

  /// Extract booking data from CreateBookingResponse
  static Map<String, dynamic> extractBookingData({
    required CreateBookingResponse response,
    required ParkingModel parking,
    required VehicleModel vehicle,
    required int selectedHours,
    required double calculatedTotal,
  }) {
    final bookingData = response.data;
    final bookingId = bookingData?.bookingId ?? 0;
    final totalAmount = bookingData?.totalAmount ?? calculatedTotal;
    
    // Parse times
    DateTime? startTime;
    DateTime? endTime;
    
    if (bookingData != null) {
      try {
        if (bookingData.startTime.isNotEmpty) {
          startTime = DateTime.parse(bookingData.startTime);
        }
        if (bookingData.endTime.isNotEmpty) {
          endTime = DateTime.parse(bookingData.endTime);
        }
      } catch (e) {
        // If parsing fails, calculate from hours
        startTime = DateTime.now();
        endTime = startTime.add(Duration(hours: bookingData.hours));
      }
    } else {
      startTime = DateTime.now();
      endTime = startTime.add(Duration(hours: selectedHours));
    }

    return {
      'parking': parking,
      'vehicle': vehicle,
      'hours': bookingData?.hours ?? selectedHours,
      'totalAmount': totalAmount,
      'bookingId': bookingId,
      if (startTime != null) 'startTime': startTime,
      if (endTime != null) 'endTime': endTime,
    };
  }

  /// Extract booking data from error response (409 conflict)
  static Map<String, dynamic>? extractBookingDataFromError({
    required Map<String, dynamic> responseData,
    required ParkingModel parking,
    required VehicleModel vehicle,
    required int selectedHours,
    required double calculatedTotal,
  }) {
    final existingBookingId = responseData['data']?['booking_id'] as int?;
    
    if (existingBookingId == null || existingBookingId <= 0) {
      return null;
    }

    final bookingDataMap = responseData['data'] as Map<String, dynamic>?;
    
    // Parse times if available
    DateTime? startTime;
    DateTime? endTime;
    
    if (bookingDataMap?['end_time'] != null) {
      try {
        final endTimeStr = bookingDataMap!['end_time'] as String;
        endTime = DateTime.parse(endTimeStr);
        startTime = endTime.subtract(Duration(hours: selectedHours));
      } catch (e) {
        startTime = DateTime.now();
        endTime = startTime.add(Duration(hours: selectedHours));
      }
    } else {
      startTime = DateTime.now();
      endTime = startTime.add(Duration(hours: selectedHours));
    }

    return {
      'parking': parking,
      'vehicle': vehicle,
      'hours': selectedHours,
      'totalAmount': calculatedTotal,
      'bookingId': existingBookingId,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

