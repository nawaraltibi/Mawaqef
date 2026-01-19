import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/user_main/user_main_bloc.dart';
import '../models/user_tab.dart';
import '../../auth/presentation/profile_page.dart';
import 'pages/user_home_page.dart';
import 'pages/user_vehicles_page.dart';
import 'pages/user_parkings_page.dart';

/// User Main Screen
/// Main screen for regular users with bottom navigation
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen>
    with AutomaticKeepAliveClientMixin<UserMainScreen> {
  late PageController _pageController;
  static const _navDuration = Duration(milliseconds: 300);

  static List<UserTab> get _bottomNavTabs => [
        UserTab.home,
        UserTab.vehicles,
        UserTab.parkings,
        UserTab.profile,
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: _navDuration,
      curve: Curves.fastOutSlowIn,
    );
    context.read<UserMainBloc>().add(ChangeUserTab(index));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<UserMainBloc, UserMainState>(
      listener: (context, state) {
        final selectedIndex = _mapSelectedIndex(state);
        if (_pageController.hasClients) {
          final currentPage = _pageController.page?.round() ?? 0;
          if (currentPage != selectedIndex) {
            _pageController.animateToPage(
              selectedIndex,
              duration: _navDuration,
              curve: Curves.fastOutSlowIn,
            );
          }
        }
      },
      child: BlocSelector<UserMainBloc, UserMainState, int>(
        selector: _mapSelectedIndex,
        builder: (context, selectedIndex) {
          return Scaffold(
            extendBody: true,
            body: SafeArea(
              bottom: false,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  UserHomePage(),
                  UserVehiclesPage(),
                  UserParkingsPage(),
                  ProfilePage(),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _mapBottomNavIndex(selectedIndex),
              onTap: (index) {
                final tab = _bottomNavTabs[index];
                final actualIndex = tab.index;
                _goToPage(actualIndex);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              items: _bottomNavTabs.map((tab) {
                return BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label(l10n),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

int _mapSelectedIndex(UserMainState state) {
  return state is UserMainInitial ? state.selectedIndex : 0;
}

int _mapBottomNavIndex(int actualIndex) {
  final tab = UserTab.values[actualIndex];
  final bottomNavIndex = _UserMainScreenState._bottomNavTabs.indexOf(tab);
  return bottomNavIndex >= 0 ? bottomNavIndex : 0;
}

