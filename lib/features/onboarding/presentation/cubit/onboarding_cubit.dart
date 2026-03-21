import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCubit extends Cubit<bool> {
  final SharedPreferences _prefs;
  static const String _onboardingCompleteKey = 'onboarding_complete';

  OnboardingCubit(this._prefs)
    : super(_prefs.getBool(_onboardingCompleteKey) ?? false);

  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingCompleteKey, true);
    emit(true);
  }
}
