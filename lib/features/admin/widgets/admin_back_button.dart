import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:prro/router/app_router.gr.dart';

/// Consistent back button for admin drill-down screens. Icon only, placed in
/// the AppBar leading slot. Pops the current route to return to the immediate
/// parent view.
class AdminBackButton extends StatelessWidget {
  const AdminBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Назад',
      onPressed: () => context.router.pop(),
    );
  }
}

/// Button that returns the user from the admin area to the login screen.
/// Uses the same icon-only pattern as [AdminBackButton] for visual
/// consistency across the admin feature.
class AdminMainMenuButton extends StatelessWidget {
  const AdminMainMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () => context.router.replace(const LoginRoute()),
    );
  }
}
