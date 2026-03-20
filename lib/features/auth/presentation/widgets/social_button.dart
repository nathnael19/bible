import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: SabaColors.outlineVariant.withValues(alpha: 0.15),
        ),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: SabaTypography.labelLarge().copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
