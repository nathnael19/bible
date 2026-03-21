import 'package:flutter/material.dart';
import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';

/// This screen is shown after the user requests a password reset email.
/// Firebase sends a link to the user's email — no OTP code is entered in-app.
class CheckEmailScreen extends StatelessWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: SabaColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: SabaColors.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // ── Header Icon ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: SabaColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.mark_email_read_rounded,
                  color: SabaColors.secondary,
                  size: 52,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                l10n.checkEmailTitle,
                style: SabaTypography.headlineLarge().copyWith(
                  color: SabaColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: SabaTypography.bodyMedium().copyWith(
                    color: SabaColors.onSurfaceVariant,
                    height: 1.6,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a password reset link to '),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        color: SabaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: '.\n\nClick the link in the email to reset your password, then come back and log in.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              // ── Back to Login CTA ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SabaColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.backToLogin,
                    style: SabaTypography.labelLarge().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // ── Resend ─────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.didNotReceiveCode,
                    style: SabaTypography.bodyMedium().copyWith(
                      color: SabaColors.onSurfaceVariant,
                    ),
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state.status == AuthStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage ?? l10n.errorOccurred)),
                        );
                      } else if (state.status == AuthStatus.initial) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reset email sent!')),
                        );
                      }
                    },
                    builder: (context, state) {
                      return TextButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : () => context.read<AuthCubit>().sendResetCode(email),
                        child: state.status == AuthStatus.loading
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                l10n.resend,
                                style: SabaTypography.bodyMedium().copyWith(
                                  color: SabaColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
