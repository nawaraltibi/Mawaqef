import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'loading_widget.dart';

/// Infinite List View Widget
/// 
/// Why this is valuable:
/// - Handles pagination automatically
/// - Shows loading indicator at the bottom
/// - Supports pull-to-refresh
/// - Reusable across all list screens
class InfiniteListViewWidget extends StatelessWidget {
  final ScrollController scrollController;
  final List<dynamic> items;
  final bool isLoading;
  final bool hasMoreData;
  final Future<void> Function() fetchMoreItems;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Future<void> Function()? onRefresh;

  const InfiniteListViewWidget({
    super.key,
    required this.scrollController,
    required this.items,
    required this.isLoading,
    required this.hasMoreData,
    required this.fetchMoreItems,
    required this.itemBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
      controller: scrollController,
      padding: padding ?? EdgeInsets.all(16.w),
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return itemBuilder(context, items[index]);
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(
              child: LoadingWidget(),
            ),
          );
        }
      },
    );

    Widget scrollListener = NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        final currentPixels = scrollInfo.metrics.pixels;
        final maxScrollExtent = scrollInfo.metrics.maxScrollExtent;
        final threshold = maxScrollExtent - 100;

        if (!isLoading && hasMoreData && currentPixels >= threshold) {
          fetchMoreItems();
        }
        return false;
      },
      child: listView,
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: scrollListener,
      );
    }

    return scrollListener;
  }
}

