part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.languageCode,
    required this.currencySymbol,
  });

  const SettingsState.initial()
      : this(
          languageCode: 'en',
          currencySymbol: r'$',
        );

  final String languageCode;
  final String currencySymbol;

  @override
  List<Object> get props => [languageCode, currencySymbol];

  SettingsState copyWith({String? languageCode, String? currencySymbol, Uint8List? profileImage}) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }
}
