import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Currency Converter"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}