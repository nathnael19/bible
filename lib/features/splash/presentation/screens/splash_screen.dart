import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../bible_reader/presentation/screens/app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      FlutterNativeSplash.remove();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AppShell()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SabaColors.primary,
              SabaColors.surfaceDark,
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo in a rounded square
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF261919),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Ethiopic Text
                  Text(
                    'ሳባ ቅዱስ ስነ-ጽሁፍ',
                    style: GoogleFonts.notoSerifEthiopic(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: SabaColors.secondaryContainer,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // English Subtext
                  Text(
                    'SABA SACRED SCRIPT',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: SabaColors.secondaryContainer.withValues(alpha: 0.7),
                      letterSpacing: 4.0,
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar and Footer
            Positioned(
              bottom: 80,
              left: 40,
              right: 40,
              child: Column(
                children: [
                  // Progress Bar
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        value: _progressAnimation.value,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(SabaColors.secondaryContainer),
                        minHeight: 1,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.import_contacts_outlined,
                        size: 16,
                        color: SabaColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ILLUMINATING THE WORD',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: SabaColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                          letterSpacing: 3.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
