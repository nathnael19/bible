import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      titleKey: 'onboardingTitle1',
      descKey: 'onboardingDesc1',
      image: 'assets/images/onboarding1.png', // Placeholder, using icons for now
      icon: Icons.auto_stories_rounded,
    ),
    OnboardingData(
      titleKey: 'onboardingTitle2',
      descKey: 'onboardingDesc2',
      image: 'assets/images/onboarding2.png',
      icon: Icons.menu_book_rounded,
    ),
    OnboardingData(
      titleKey: 'onboardingTitle3',
      descKey: 'onboardingDesc3',
      image: 'assets/images/onboarding3.png',
      icon: Icons.trending_up_rounded,
    ),
    OnboardingData(
      titleKey: 'onboardingTitle4',
      descKey: 'onboardingDesc4',
      image: 'assets/images/onboarding4.png',
      icon: Icons.lightbulb_outline_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SabaColors.surfaceDark,
              SabaColors.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.read<OnboardingCubit>().completeOnboarding(),
                  child: Text(
                    l10n.onboardingSkip,
                    style: SabaTypography.labelLarge().copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _OnboardingPage(data: page);
                  },
                ),
              ),
              // Bottom Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  children: [
                    // Dot Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? SabaColors.secondaryContainer : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Next / Get Started Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            context.read<OnboardingCubit>().completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SabaColors.secondaryContainer,
                          foregroundColor: SabaColors.onSecondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? l10n.onboardingGetStarted : l10n.onboardingNext,
                          style: SabaTypography.labelLarge().copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String titleKey;
  final String descKey;
  final String image;
  final IconData icon;

  OnboardingData({
    required this.titleKey,
    required this.descKey,
    required this.image,
    required this.icon,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    // Map keys to actual localized strings
    final title = _getLocalizedValue(context, data.titleKey);
    final desc = _getLocalizedValue(context, data.descKey);

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration / Icon Placeholder
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: SabaColors.secondaryContainer,
            ),
          ),
          const SizedBox(height: 64),
          Text(
            title,
            textAlign: TextAlign.center,
            style: SabaTypography.headlineLarge().copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: SabaTypography.bodyLarge().copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedValue(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'onboardingTitle1': return l10n.onboardingTitle1;
      case 'onboardingDesc1': return l10n.onboardingDesc1;
      case 'onboardingTitle2': return l10n.onboardingTitle2;
      case 'onboardingDesc2': return l10n.onboardingDesc2;
      case 'onboardingTitle3': return l10n.onboardingTitle3;
      case 'onboardingDesc3': return l10n.onboardingDesc3;
      case 'onboardingTitle4': return l10n.onboardingTitle4;
      case 'onboardingDesc4': return l10n.onboardingDesc4;
      default: return '';
    }
  }
}
