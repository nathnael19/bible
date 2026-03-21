import 'package:bible/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/bible_reader/presentation/screens/app_shell.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/social_button.dart';
import 'login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: SabaColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo Section ──────────────────────────────────────────────
                Container(
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: SabaColors.primary.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Titles ────────────────────────────────────────────────────
                Text(
                  l10n.createAccountTitle,
                  style: SabaTypography.headlineLarge().copyWith(
                    color: SabaColors.primary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.registerSubtitle,
                  style: SabaTypography.bodyMedium().copyWith(
                    color: SabaColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ── Form Section ──────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldTitle(l10n.fullName),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          hintText: l10n.fullNameHint,
                          prefixIcon: const Icon(Icons.person_outline, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFieldTitle(l10n.email),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'email@example.com',
                          prefixIcon: Icon(Icons.alternate_email, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFieldTitle(l10n.password),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _isPasswordVisible = !_isPasswordVisible);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFieldTitle(l10n.confirmPassword),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Terms & Conditions ─────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                              activeColor: SabaColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: SabaTypography.bodySmall().copyWith(
                                  color: SabaColors.onSurfaceVariant,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(text: l10n.registerTermsPrefix),
                                  TextSpan(
                                    text: l10n.termsAndConditions,
                                    style: const TextStyle(
                                      color: SabaColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: l10n.registerTermsAnd),
                                  TextSpan(
                                    text: l10n.privacyPolicy,
                                    style: const TextStyle(
                                      color: SabaColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: l10n.registerTermsSuffix),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // ── Register Button ────────────────────────────────────
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state.status == AuthStatus.authenticated) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const AppShell()),
                              (route) => false,
                            );
                          } else if (state.status == AuthStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage ?? l10n.registrationFailed)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state.status == AuthStatus.loading || !_agreedToTerms
                                  ? null
                                  : () {
                                      if (_passwordController.text != _confirmPasswordController.text) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(l10n.passwordsDontMatch)),
                                        );
                                        return;
                                      }
                                      context.read<AuthCubit>().register(
                                            _fullNameController.text,
                                            _emailController.text,
                                            _passwordController.text,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SabaColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: state.status == AuthStatus.loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          l10n.registerNow,
                                          style: SabaTypography.labelLarge().copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Divider ──────────────────────────────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.or,
                        style: SabaTypography.labelSmall().copyWith(
                          color: SabaColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Social Login ─────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: SocialButton(
                        icon: Icons.g_mobiledata,
                        label: 'Google',
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SocialButton(
                        icon: Icons.apple,
                        label: 'Apple',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // ── Footer ───────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: SabaTypography.bodyMedium().copyWith(
                        color: SabaColors.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        l10n.loginLink,
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
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Text(
      title,
      style: SabaTypography.labelSmall().copyWith(
        color: SabaColors.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
