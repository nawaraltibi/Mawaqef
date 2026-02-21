/// Owner Dashboard Stats Response Model
/// Response from GET /api/owner/alldataofinvestor endpoint
class OwnerDashboardStatsResponse {
  final bool success;
  final String message;
  final DashboardData data;

  OwnerDashboardStatsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OwnerDashboardStatsResponse.fromJson(Map<String, dynamic> json) {
    return OwnerDashboardStatsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? DashboardData.fromJson(json['data'] as Map<String, dynamic>)
          : throw Exception('Data is required in dashboard stats response'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Dashboard Data Model
/// Contains all dashboard statistics
class DashboardData {
  final SummaryStats summary;
  final OccupancyStats occupancyStats;
  final FinancialStats financialStats;
  final BookingStats bookingStats;
  final String? timestamp;

  DashboardData({
    required this.summary,
    required this.occupancyStats,
    required this.financialStats,
    required this.bookingStats,
    this.timestamp,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      summary: json['summary'] != null
          ? SummaryStats.fromJson(json['summary'] as Map<String, dynamic>)
          : throw Exception('Summary stats are required'),
      occupancyStats: json['occupancy_stats'] != null
          ? OccupancyStats.fromJson(json['occupancy_stats'] as Map<String, dynamic>)
          : throw Exception('Occupancy stats are required'),
      financialStats: json['financial_stats'] != null
          ? FinancialStats.fromJson(json['financial_stats'] as Map<String, dynamic>)
          : throw Exception('Financial stats are required'),
      bookingStats: json['booking_stats'] != null
          ? BookingStats.fromJson(json['booking_stats'] as Map<String, dynamic>)
          : throw Exception('Booking stats are required'),
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'occupancy_stats': occupancyStats.toJson(),
      'financial_stats': financialStats.toJson(),
      'booking_stats': bookingStats.toJson(),
      'timestamp': timestamp,
    };
  }
}

/// Summary Statistics Model
class SummaryStats {
  final String ownerName;
  final int totalParkings;
  final int activeParkings;
  final int pendingParkings;
  final int rejectedParkings;

  SummaryStats({
    required this.ownerName,
    required this.totalParkings,
    required this.activeParkings,
    required this.pendingParkings,
    required this.rejectedParkings,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    return SummaryStats(
      ownerName: json['owner_name'] as String? ?? '',
      totalParkings: _parseInt(json['total_parkings']),
      activeParkings: _parseInt(json['active_parkings']),
      pendingParkings: _parseInt(json['pending_parkings']),
      rejectedParkings: _parseInt(json['rejected_parkings']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_name': ownerName,
      'total_parkings': totalParkings,
      'active_parkings': activeParkings,
      'pending_parkings': pendingParkings,
      'rejected_parkings': rejectedParkings,
    };
  }
}

/// Occupancy Statistics Model
/// 
/// Contains availability computed from camera-based vacant_spaces:
/// - [availableSpaces]: Available spaces (from sum of vacant_spaces)
/// - [occupiedSpaces]: Occupied spaces (from sum of vacant_spaces)
class OccupancyStats {
  final int totalSpaces;
  final int availableSpaces;
  final int occupiedSpaces;
  final String occupancyRate; // e.g., "75.5%"
  final String occupancyLevel; // e.g., "عالية"

  OccupancyStats({
    required this.totalSpaces,
    required this.availableSpaces,
    required this.occupiedSpaces,
    required this.occupancyRate,
    required this.occupancyLevel,
  });

  factory OccupancyStats.fromJson(Map<String, dynamic> json) {
    return OccupancyStats(
      totalSpaces: _parseInt(json['total_spaces']),
      availableSpaces: _parseInt(json['available_spaces']),
      occupiedSpaces: _parseInt(json['occupied_spaces']),
      occupancyRate: json['occupancy_rate'] as String? ?? '0%',
      occupancyLevel: json['occupancy_level'] as String? ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_spaces': totalSpaces,
      'available_spaces': availableSpaces,
      'occupied_spaces': occupiedSpaces,
      'occupancy_rate': occupancyRate,
      'occupancy_level': occupancyLevel,
    };
  }

  /// Get display-friendly available spaces
  int get displayAvailableSpaces => availableSpaces;

  /// Get display-friendly occupied spaces
  int get displayOccupiedSpaces => occupiedSpaces;
}

/// Financial Statistics Model
class FinancialStats {
  final double totalRevenue;
  final String formattedTotalRevenue; // e.g., "1,234.56 ل.س"
  final int successfulPayments;
  final String averageHourlyRate; // e.g., "5.00 ل.س/ساعة"
  final RevenueByPeriod revenueByPeriod;

  FinancialStats({
    required this.totalRevenue,
    required this.formattedTotalRevenue,
    required this.successfulPayments,
    required this.averageHourlyRate,
    required this.revenueByPeriod,
  });

  factory FinancialStats.fromJson(Map<String, dynamic> json) {
    return FinancialStats(
      totalRevenue: _parseDouble(json['total_revenue']),
      formattedTotalRevenue: json['formatted_total_revenue'] as String? ?? '0.00 ل.س',
      successfulPayments: _parseInt(json['successful_payments']),
      averageHourlyRate: json['average_hourly_rate'] as String? ?? '0.00 ل.س/ساعة',
      revenueByPeriod: json['revenue_by_period'] != null
          ? RevenueByPeriod.fromJson(json['revenue_by_period'] as Map<String, dynamic>)
          : RevenueByPeriod(today: '0.00 ل.س', thisWeek: '0.00 ل.س', thisMonth: '0.00 ل.س'),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_revenue': totalRevenue,
      'formatted_total_revenue': formattedTotalRevenue,
      'successful_payments': successfulPayments,
      'average_hourly_rate': averageHourlyRate,
      'revenue_by_period': revenueByPeriod.toJson(),
    };
  }
}

/// Revenue by Period Model
class RevenueByPeriod {
  final String today; // e.g., "100.00 ل.س"
  final String thisWeek; // e.g., "500.00 ل.س"
  final String thisMonth; // e.g., "2000.00 ل.س"

  RevenueByPeriod({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });

  factory RevenueByPeriod.fromJson(Map<String, dynamic> json) {
    return RevenueByPeriod(
      today: json['today'] as String? ?? '0.00 ل.س',
      thisWeek: json['this_week'] as String? ?? '0.00 ل.س',
      thisMonth: json['this_month'] as String? ?? '0.00 ل.س',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'this_week': thisWeek,
      'this_month': thisMonth,
    };
  }
}

/// Booking Statistics Model
class BookingStats {
  final int totalBookings;
  final int activeBookings;
  final int cancelledBookings;
  final int activeBookingsNow;

  BookingStats({
    required this.totalBookings,
    required this.activeBookings,
    required this.cancelledBookings,
    required this.activeBookingsNow,
  });

  factory BookingStats.fromJson(Map<String, dynamic> json) {
    return BookingStats(
      totalBookings: _parseInt(json['total_bookings']),
      activeBookings: _parseInt(json['active_bookings']),
      cancelledBookings: _parseInt(json['cancelled_bookings']),
      activeBookingsNow: _parseInt(json['active_bookings_now']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bookings': totalBookings,
      'active_bookings': activeBookings,
      'cancelled_bookings': cancelledBookings,
      'active_bookings_now': activeBookingsNow,
    };
  }
}

