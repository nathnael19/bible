import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/core/services/local_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorage _storage;

  ThemeCubit(this._storage) : super(_storage.getThemeMode());

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setTheme(newMode);
  }

  void setTheme(ThemeMode mode) {
    _storage.setThemeMode(mode);
    emit(mode);
  }
}
