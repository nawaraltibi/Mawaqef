import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/bookings_list_refresh_notifier.dart';
import '../../../../core/services/home_refresh_notifier.dart';
import '../../../../core/services/vehicles_list_refresh_notifier.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../models/user_tab.dart';
import '../widgets/modern_bottom_nav_bar.dart';

/// Shell for user main flow: persistent bottom nav + branch content.
/// Used with StatefulShellRoute so detail screens (booking details, vehicle add, etc.)
/// keep the bottom nav visible.
///
/// Note: Do NOT wrap [navigationShell] in AnimatedSwitcher/KeyedSubtree — it has
/// an internal GlobalKey; wrapping causes "Duplicate GlobalKey" during tab switches.
class UserMainShell extends StatelessWidget {
  const UserMainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _bottomNavTabs = [
    UserTab.home,
    UserTab.vehicles,
    UserTab.bookings,
    UserTab.profile,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: true,
        child: navigationShell,
      ),
      bottomNavigationBar: ModernBottomNavBar(
        items: _bottomNavTabs.map((tab) {
          return ModernNavItem(
            icon: tab.icon,
            label: tab.label(l10n),
            activeIcon: _getActiveIcon(tab.icon, tab),
          );
        }).toList(),
        selectedIndex: navigationShell.currentIndex,
        onTap: (index) {
          if (index == navigationShell.currentIndex) return;
          final path = _pathForTabIndex(index);
          switch (index) {
            case 0:
              getIt<HomeRefreshNotifier>().requestRefresh();
              break;
            case 1:
              getIt<VehiclesListRefreshNotifier>().requestRefresh();
              break;
            case 2:
              getIt<BookingsListRefreshNotifier>().requestRefresh();
              break;
            case 3:
              break;
          }
          context.goAndClearStack(path);
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        unselectedColor: AppColors.secondaryText,
        height: 58,
        showLabels: true,
        elevation: 12,
      ),
    );
  }

  static IconData _getActiveIcon(IconData outlinedIcon, UserTab tab) {
    switch (tab) {
      case UserTab.home:
        return Icons.home;
      case UserTab.vehicles:
        return Icons.directions_car;
      case UserTab.bookings:
        return Icons.local_parking;
      case UserTab.parkings:
        return Icons.bookmark;
      case UserTab.profile:
        return Icons.person;
    }
  }

  static String _pathForTabIndex(int index) {
    switch (index) {
      case 0:
        return Routes.userMainHomePath;
      case 1:
        return Routes.userMainVehiclesPath;
      case 2:
        return Routes.userMainBookingsPath;
      case 3:
        return Routes.userMainProfilePath;
      default:
        return Routes.userMainHomePath;
    }
  }
}
