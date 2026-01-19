import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

/// Owner bottom navigation tabs
enum OwnerTab {
  parkingManagement,
  profile,
}

extension OwnerTabX on OwnerTab {
  IconData get icon {
    switch (this) {
      case OwnerTab.parkingManagement:
        return Icons.local_parking;
      case OwnerTab.profile:
        return Icons.person_outline;
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case OwnerTab.parkingManagement:
        return l10n.ownerTabParkingManagement;
      case OwnerTab.profile:
        return l10n.ownerTabProfile;
    }
  }

  int get index {
    switch (this) {
      case OwnerTab.parkingManagement:
        return 0;
      case OwnerTab.profile:
        return 1;
    }
  }
}

