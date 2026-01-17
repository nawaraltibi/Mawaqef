import 'package:flutter/material.dart';
import '../enums/loading_type.dart';
import '../styles/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final bool withPadding;
  final LoadingType type;
  final double? height;
  final String? message;

  const LoadingWidget({
    super.key,
    this.withPadding = true,
    this.type = LoadingType.normal,
    this.height,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    double indicatorSize;
    switch (type) {
      case LoadingType.small:
        indicatorSize = 24;
        break;
      case LoadingType.large:
        indicatorSize = 48;
        break;
      case LoadingType.normal:
        indicatorSize = height ?? 40;
        break;
    }

    final loadingIndicator = Padding(
      padding: withPadding ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: Center(
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
    );

    if (message != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loadingIndicator,
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(fontSize: 14, color: AppColors.secondaryText),
          ),
        ],
      );
    }

    return loadingIndicator;
  }
}

