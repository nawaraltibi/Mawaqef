import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

/// Custom dropdown field with search functionality
///
/// Why this is valuable:
/// - Searchable dropdown for large lists
/// - Consistent UI across the app
/// - Supports custom filtering logic
/// - Better UX than standard dropdown for many items
class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final T? selectedValue;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) getLabel;
  final bool isRequired;
  final bool Function(T, String)? filterFunction;

   const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    required this.getLabel,
    this.selectedValue,
    this.isRequired = false,
    this.filterFunction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final useSearch = items.length > 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.fieldLabel(context)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: useSearch ? () => _showSearchDialog(context) : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: useSearch ? 16.w : 10.w,
              vertical: useSearch ? 14.h : 10.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.brightWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: useSearch
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedValue != null
                              ? getLabel(selectedValue as T)
                              : l10n?.vehiclesFormPleaseSelect ??
                                    'Please select',
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: selectedValue != null
                                ? AppColors.primaryText
                                : AppColors.secondaryText,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ],
                  )
                : DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: selectedValue,
                      isExpanded: true,
                      isDense: true,
                      hint: Text(
                        selectedValue != null
                            ? getLabel(selectedValue as T)
                            : l10n?.vehiclesFormPleaseSelect ?? 'Please select',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      items: items.map((T item) {
                        return DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            getLabel(item),
                            style: AppTextStyles.bodyMedium(context),
                          ),
                        );
                      }).toList(),
                      onChanged: onChanged,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showSearchDialog(BuildContext context) async {
    final T? result = await showDialog<T>(
      context: context,
      builder: (BuildContext dialogContext) {
        return _SearchableDropdownDialog<T>(
          items: items,
          selectedValue: selectedValue,
          getLabel: getLabel,
          filterFunction: filterFunction,
          parentContext: context,
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

/// Dialog for searching and selecting an item
class _SearchableDropdownDialog<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final String Function(T) getLabel;
  final bool Function(T, String)? filterFunction;
  final BuildContext parentContext;

  const _SearchableDropdownDialog({
    required this.items,
    required this.selectedValue,
    required this.getLabel,
    required this.filterFunction,
    required this.parentContext,
  });

  @override
  State<_SearchableDropdownDialog<T>> createState() =>
      _SearchableDropdownDialogState<T>();
}

class _SearchableDropdownDialogState<T>
    extends State<_SearchableDropdownDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  late final ValueNotifier<List<T>> _filteredItemsNotifier;

  @override
  void initState() {
    super.initState();
    _filteredItemsNotifier = ValueNotifier<List<T>>(widget.items);
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredItemsNotifier.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredItemsNotifier.value = widget.items;
    } else {
      _filteredItemsNotifier.value = widget.items.where((item) {
        if (widget.filterFunction != null) {
          return widget.filterFunction!(item, query);
        }
        // Default filter using getLabel
        final label = widget.getLabel(item).toLowerCase();
        return label.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          children: [
            // Header with search
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(
                                context,
                              )?.vehiclesFormPleaseSelect ??
                              'Please select',
                          style: AppTextStyles.titleLarge(
                            context,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.brightWhite,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // List of items - use Expanded to take remaining space
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
                child: ValueListenableBuilder<List<T>>(
                  valueListenable: _filteredItemsNotifier,
                  builder: (context, filteredItems, child) {
                    if (filteredItems.isEmpty) {
                      return Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        child: Center(
                          child: Text(
                            'No data',
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredItems.length,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = widget.selectedValue == item;

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(color: AppColors.primary, width: 2)
                                : null,
                            borderRadius: BorderRadius.circular(16.r),
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : AppColors.brightWhite,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(item);
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.getLabel(item),
                                      style:
                                          AppTextStyles.bodyMedium(
                                            context,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.primaryText,
                                          ).copyWith(
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                      size: 22.sp,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
