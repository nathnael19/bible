import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
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
                  'አዲስ አካውንት ይፍጠሩ',
                  style: SabaTypography.headlineLarge().copyWith(
                    color: SabaColors.primary,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'የሳባ ቅርስን ይቀላቀሉ እና የተቀደሱ መጽሐፍትን ያንብቡ',
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
                      _buildFieldTitle('ሙሉ ስም'),
                      const SizedBox(height: 8),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'ሙሉ ስምዎን እዚህ ያስገቡ',
                          prefixIcon: Icon(Icons.person_outline, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFieldTitle('ኢሜይል'),
                      const SizedBox(height: 8),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'email@example.com',
                          prefixIcon: Icon(Icons.alternate_email, size: 20),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildFieldTitle('የይለፍ ቃል'),
                      const SizedBox(height: 8),
                      TextField(
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

                      _buildFieldTitle('የይለፍ ቃል ያረጋግጡ'),
                      const SizedBox(height: 8),
                      TextField(
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
                                  const TextSpan(text: 'በመመዝገብ በሳባ ቅርስ '),
                                  TextSpan(
                                    text: 'ውሎች እና ሁኔታዎች',
                                    style: TextStyle(
                                      color: SabaColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: ' እንዲሁም በ'),
                                  TextSpan(
                                    text: 'ግላዊነት መመሪያው',
                                    style: TextStyle(
                                      color: SabaColors.secondary,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  const TextSpan(text: ' መስማማትዎን ያረጋግጣሉ።'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // ── Register Button ────────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SabaColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'አሁን ይመዝገቡ',
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ── Footer ───────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'አስቀድመው አካውንት አለዎት? ',
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
                        'ይግቡ (Log In)',
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
