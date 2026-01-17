import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/app_colors.dart';

/// Custom date picker field
/// 
/// Why this is valuable:
/// - Consistent date picking UI across the app
/// - Supports date and datetime selection
/// - Handles min/max date constraints
/// - Follows app design system
class CustomDatePickerField extends StatelessWidget {
  final String label;
  final String? selectedDate;
  final Function(String) onDateSelected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool isRequired;
  final bool pickTime; // if true, also pick time and return yyyy-MM-dd HH:mm:ss

  const CustomDatePickerField({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
    this.minDate,
    this.maxDate,
    this.isRequired = false,
    this.pickTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.brightWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate?.isNotEmpty == true
                        ? selectedDate!
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedDate?.isNotEmpty == true
                          ? AppColors.primaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Resolve range
    DateTime firstDate = minDate ?? DateTime(1900);
    DateTime lastDate = maxDate ?? DateTime(2100);

    // If range is invalid, fix it by aligning lastDate to firstDate
    if (firstDate.isAfter(lastDate)) {
      lastDate = firstDate;
    }

    // Compute a safe initial date inside [firstDate, lastDate]
    DateTime initialDate;
    final parsed = (selectedDate != null && selectedDate!.isNotEmpty)
        ? DateTime.tryParse(selectedDate!)
        : null;
    if (parsed != null) {
      if (parsed.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (parsed.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = parsed;
      }
    } else {
      final now = DateTime.now();
      if (now.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (now.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = now;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.brightWhite,
              surface: AppColors.brightWhite,
              onSurface: AppColors.primaryText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      DateTime finalDateTime = picked;
      if (pickTime) {
        final TimeOfDay initialTime = TimeOfDay.fromDateTime(DateTime.now());
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: AppColors.brightWhite,
                  surface: AppColors.brightWhite,
                  onSurface: AppColors.primaryText,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          finalDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      }

      if (context.mounted) {
        String two(int v) => v.toString().padLeft(2, '0');
        final String formatted = pickTime
            ? '${finalDateTime.year}-${two(finalDateTime.month)}-${two(finalDateTime.day)} ${two(finalDateTime.hour)}:${two(finalDateTime.minute)}:00'
            : '${finalDateTime.year}-${two(finalDateTime.month)}-${two(finalDateTime.day)}';
        onDateSelected(formatted);
      }
    }
  }
}

