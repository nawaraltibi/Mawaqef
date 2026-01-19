import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/owner_main/owner_main_bloc.dart';
import '../models/owner_tab.dart';
import '../../auth/presentation/profile_page.dart';
import 'pages/owner_parking_management_page.dart';

/// Owner Main Screen
/// Main screen for parking owners with bottom navigation
class OwnerMainScreen extends StatefulWidget {
  const OwnerMainScreen({super.key});

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen>
    with AutomaticKeepAliveClientMixin<OwnerMainScreen> {
  late PageController _pageController;
  static const _navDuration = Duration(milliseconds: 300);

  static List<OwnerTab> get _bottomNavTabs => [
        OwnerTab.parkingManagement,
        OwnerTab.profile,
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
    context.read<OwnerMainBloc>().add(ChangeOwnerTab(index));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<OwnerMainBloc, OwnerMainState>(
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
      child: BlocSelector<OwnerMainBloc, OwnerMainState, int>(
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
                  OwnerParkingManagementPage(),
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

int _mapSelectedIndex(OwnerMainState state) {
  return state is OwnerMainInitial ? state.selectedIndex : 0;
}

int _mapBottomNavIndex(int actualIndex) {
  final tab = OwnerTab.values[actualIndex];
  final bottomNavIndex = _OwnerMainScreenState._bottomNavTabs.indexOf(tab);
  return bottomNavIndex >= 0 ? bottomNavIndex : 0;
}

