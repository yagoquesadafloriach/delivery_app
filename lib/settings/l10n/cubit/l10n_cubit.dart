import 'package:bloc/bloc.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';

class L10nCubit extends Cubit<Locale> {
  L10nCubit({
    required String lenguageCode,
    required this.settingsCubit,
  }) : super(Locale(lenguageCode)) {
    _setUpListeners();
  }

  final SettingsCubit settingsCubit;

  String get languageCode => state.languageCode;

  Future<void> _setUpListeners() async {
    final locale = _getLocaleSettings();

    if (locale != null) {
      emit(locale);
    }
  }

  Locale? _getLocaleSettings() {
    final languageCode = settingsCubit.getLanguageCode();

    if (languageCode != null) {
      return Locale(languageCode);
    }

    return null;
  }

  void changeLocale({required String languageCode}) {
    emit(Locale(languageCode));
    settingsCubit.setLanguageCode(languageCode: languageCode);
  }
}
