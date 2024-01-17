import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/settings/data/settings_repository.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required this.settingsRepository,
    required this.authBloc,
  }) : super(const SettingsState.initial()) {
    _getDefaultCurrency();
  }

  final SettingsRepository settingsRepository;

  final AuthBloc authBloc;

  String get currencySymbol => state.currencySymbol;

  void _getDefaultCurrency() {
    final currencySymbol = _getCurrency();
    emit(SettingsState(currencySymbol: currencySymbol, languageCode: 'en'));
  }

  void setLanguageCode({required String languageCode}) => settingsRepository.setLanguageCode(languageCode: languageCode);
  String? getLanguageCode() => settingsRepository.getLanguageCode();

  void _setCurrency({required String currencySymbol}) => settingsRepository.setCurrency(currencySymbol: currencySymbol);
  String _getCurrency() => settingsRepository.getCurrency();

  void changeCurrency({required String currencySymbol}) {
    if (currencySymbol != state.currencySymbol) {
      emit(state.copyWith(currencySymbol: currencySymbol));
      _setCurrency(currencySymbol: currencySymbol);
    }
  }

  String getCurrencyFormattedText({required double value}) {
    return CurrencyTextInputFormatter(
      symbol: state.currencySymbol,
    ).format(value.toStringAsFixed(2));
  }
}
