import 'package:flutter/material.dart';
import 'package:flutter_currency_converter/core/theme/app_dimens.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onTap;

  const SwapButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(
          color: Colors.black12,
          thickness: 1.0,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.base / 2),
            decoration: const BoxDecoration(
              color: AppTheme.accentGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.swap_vert,
              color: Colors.white,
              size: 32.0,
            ),
          ),
        ),
      ],
    );
  }
}