import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';

class DashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: Theme.of(context).cardColor,
      indicatorColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
      elevation: 10,
      shadowColor: Colors.black12,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.currency_exchange_outlined),
          selectedIcon: Icon(Icons.currency_exchange, color: AppTheme.primaryBlue),
          label: 'Convert',
        ),
        NavigationDestination(
          icon: Icon(Icons.show_chart_rounded),
          selectedIcon: Icon(Icons.show_chart_rounded, color: AppTheme.primaryBlue),
          label: 'Trends',
        ),
      ],
    );
  }
}