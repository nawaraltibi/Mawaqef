import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/app_colors.dart';

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
    final useSearch = items.length > 4;

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
                              : 'Please select',
                          style: TextStyle(
                            fontSize: 14.sp,
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
                            : 'Please select',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.primaryText,
                        ),
                      ),
                      items: items.map((T item) {
                        return DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            getLabel(item),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryText,
                            ),
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
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          if (widget.filterFunction != null) {
            return widget.filterFunction!(item, query);
          }
          // Default filter using getLabel
          final label = widget.getLabel(item).toLowerCase();
          return label.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with search
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Please select',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
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
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(color: AppColors.primary),
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
            // List of items
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        'No data',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
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
                            borderRadius: BorderRadius.circular(8.r),
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.brightWhite,
                          ),
                          child: ListTile(
                            selected: isSelected,
                            title: Text(
                              widget.getLabel(item),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.primaryText,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                    size: 24.sp,
                                  )
                                : null,
                            onTap: () {
                              Navigator.of(context).pop(item);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

