import 'package:flutter/material.dart';
import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';

class CheckEmailScreen extends StatefulWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SabaColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mark_email_read_rounded,
                  color: SabaColors.secondary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.checkEmailTitle,
                style: SabaTypography.headlineLarge().copyWith(
                  color: SabaColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: SabaTypography.bodyMedium().copyWith(
                    color: SabaColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: l10n.checkEmailSubtitle1),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                        color: SabaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: l10n.checkEmailSubtitle2),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ── OTP Inputs ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => SizedBox(
                    width: 64,
                    height: 64,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: SabaTypography.headlineMedium().copyWith(
                        fontWeight: FontWeight.bold,
                        color: SabaColors.primary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: SabaColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: SabaColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // ── Verify Button ──────────────────────────────────────────────
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage ?? l10n.errorOccurred)),
                    );
                  } else if (state.status == AuthStatus.initial && _code.length == 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.passwordChangedSuccess)),
                    );
                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.status == AuthStatus.loading || _code.length < 4
                          ? null
                          : () => context.read<AuthCubit>().verifyResetCode(_code),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SabaColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state.status == AuthStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              l10n.verify,
                              style: SabaTypography.labelLarge().copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
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
                  TextButton(
                    onPressed: () async {
                      await context.read<AuthCubit>().sendResetCode(widget.email);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.codeResent)),
                        );
                      }
                    },
                    child: Text(
                      l10n.resend,
                      style: SabaTypography.bodyMedium().copyWith(
                        color: SabaColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
