import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../vehicles/presentation/utils/vehicle_translations.dart';
import '../../../models/booking_model.dart';

/// Vehicle Display Widget
/// Reusable component for displaying vehicle information
/// 
/// Used in BookingCard, ActiveBookingCard, VehicleInfoCard
class VehicleDisplayWidget extends StatelessWidget {
  final VehicleInfo? vehicle;
  final bool showIcon;
  final bool showMakeModel;
  final bool showPlateNumber;
  final bool compact;
  final TextStyle? plateNumberStyle;
  final TextStyle? makeModelStyle;

  const VehicleDisplayWidget({
    super.key,
    required this.vehicle,
    this.showIcon = true,
    this.showMakeModel = true,
    this.showPlateNumber = true,
    this.compact = false,
    this.plateNumberStyle,
    this.makeModelStyle,
  });

  /// Get vehicle type string (make + model)
  String _getVehicleType(BuildContext context) {
    if (vehicle == null) return '';
    
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return '';

    final parts = <String>[];
    if (vehicle!.carMake != null && vehicle!.carMake!.isNotEmpty) {
      final carMakeTranslated = VehicleTranslations.getCarMakeTranslation(
        vehicle!.carMake!,
        l10n,
      );
      parts.add(carMakeTranslated);
    }
    if (vehicle!.carModel != null && vehicle!.carModel!.isNotEmpty) {
      parts.add(vehicle!.carModel!);
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (vehicle == null) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return _buildCompactView(context);
    }

    return _buildFullView(context);
  }

  Widget _buildCompactView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.directions_car,
              size: 16.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 6.w),
          ],
          if (showMakeModel && _getVehicleType(context).isNotEmpty) ...[
            Flexible(
              child: Text(
                _getVehicleType(context),
                style: makeModelStyle ??
                    AppTextStyles.bodySmall(
                      context,
                      color: AppColors.secondaryText,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 1,
              height: 14.h,
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
            SizedBox(width: 8.w),
          ],
          if (showPlateNumber)
            Text(
              vehicle!.platNumber,
              style: plateNumberStyle ??
                  AppTextStyles.bodySmall(
                    context,
                    color: AppColors.primaryText,
                  ).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullView(BuildContext context) {
    final vehicleType = _getVehicleType(context);
    final color = vehicle!.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIcon || vehicleType.isNotEmpty) ...[
          Row(
            children: [
              if (showIcon) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    size: 32.sp,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(width: 16.w),
              ],
              if (vehicleType.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicleType,
                        style: makeModelStyle ??
                            AppTextStyles.titleMedium(
                              context,
                              color: AppColors.primaryText,
                            ),
                      ),
                      if (color != null && color.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          VehicleTranslations.getColorTranslation(
                            color,
                            AppLocalizations.of(context)!,
                          ),
                          style: AppTextStyles.bodySmall(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
        if (showPlateNumber) ...[
          SizedBox(height: 20.h),
          Divider(color: AppColors.border, height: 1),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.vehiclesFormPlateLabel,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                vehicle!.platNumber,
                style: plateNumberStyle ??
                    AppTextStyles.titleMedium(
                      context,
                      color: AppColors.primaryText,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

