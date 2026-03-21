import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible/core/services/local_storage.dart';

class LocaleCubit extends Cubit<Locale> {
  final LocalStorage _storage;

  LocaleCubit(this._storage) : super(Locale(_storage.getLocale()));

  void setLocale(Locale locale) {
    _storage.setLocale(locale.languageCode);
    emit(locale);
  }

  void toggleLocale() {
    final newLocale = state.languageCode == 'am' ? const Locale('en') : const Locale('am');
    setLocale(newLocale);
  }
}
