import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prro/features/auth/bloc/auth_bloc.dart';
import 'package:prro/features/auth/bloc/auth_state.dart';
import 'package:prro/features/seller/bloc/balance/balance_cubit.dart';
import 'package:prro/features/seller/widgets/custom_popup_menu.dart';
import 'package:prro/features/seller/widgets/search_field.dart';

class ResponsiveSellerAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ResponsiveSellerAppBar({
    required this.onLogout,
    required this.onCloseShift,
    required this.theme,
    this.shiftMenuBuilder,
    super.key,
  });

  final VoidCallback onLogout;
  final VoidCallback onCloseShift;
  final ThemeData theme;
  final Widget Function(BuildContext context, {required bool isNarrow})?
  shiftMenuBuilder;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ResponsiveSellerAppBar> createState() => _ResponsiveSellerAppBarState();
}

class _ResponsiveSellerAppBarState extends State<ResponsiveSellerAppBar> {
  bool _isSearching = false;
  bool _isNarrow = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _isNarrow = constraints.maxWidth < 600;
        return AppBar(
          backgroundColor: widget.theme.appBarTheme.backgroundColor,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: _isSearching
                ? Row(
                    key: const ValueKey('search'),
                    children: [
                      IconButton(
                        onPressed: _exitSearch,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: SearchField(fullWidth: true, autofocus: true),
                      ),
                    ],
                  )
                : _buildNormalTitle(context),
          ),
        );
      },
    );
  }

  Widget _buildNormalTitle(BuildContext context) {
    final username = Row(
      key: const ValueKey('normal'),
      children: [
        TextButton.icon(
          onPressed: widget.onLogout,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          label: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
        ),
        const SizedBox(width: 2),
        if (widget.shiftMenuBuilder != null)
          widget.shiftMenuBuilder!(context, isNarrow: _isNarrow),
        const SizedBox(width: 2),
        CustomPopupMenu(
          name: _isNarrow ? '' : 'Каса',
          icon: Icons.attach_money_sharp,
          widgets: [
            BlocBuilder<BalanceCubit, BalanceState>(
              bloc: context.read<BalanceCubit>(),
              builder: (blocContext, state) => _buildBalance(state),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: _enterSearch,
          icon: const Icon(Icons.search, color: Colors.white),
          tooltip: 'Пошук',
        ),
        const CustomPopupMenu(name: '', icon: Icons.notifications),
        const SizedBox(width: 2),
        _buildUsername(context),
      ],
    );

    if (!_isNarrow) {
      return Row(
        key: const ValueKey('normal-wide'),
        children: [
          ...username.children,
        ],
      );
    }

    return username;
  }

  void _enterSearch() {
    if (!_isSearching) {
      setState(() => _isSearching = true);
    }
  }

  void _exitSearch() {
    if (_isSearching) {
      setState(() => _isSearching = false);
    }
  }

  Widget _buildUsername(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state) {
        return switch (state) {
          AuthAuthenticated(: final user) => CustomPopupMenu(
            name: _isNarrow ? '' : user.username,
            icon: Icons.lock,
          ),
          AuthLoading() => const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          _ => CustomPopupMenu(name: _isNarrow ? '' : '...', icon: Icons.lock),
        };
      },
    );
  }

  Widget _buildBalance(BalanceState state) {
    switch (state) {
      case BalanceLoaded(:final balance):
        return Text('balance: ${balance.toStringAsFixed(2)}');
      case BalanceLoading():
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('balance: '),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        );
      case BalanceError(:final message):
        return Text(
          'Помилка: $message',
          style: const TextStyle(color: Colors.redAccent),
        );
      default:
        return const Text('balance: ...');
    }
  }
}
