import 'package:hive/hive.dart';

class HiveSettingsService {
  final Box<String> _settingsBox = Hive.box('settings');

  String? getLanguageCode() => _settingsBox.get('languageCode');
  void setLanguageCode({required String languageCode}) => _settingsBox.put('languageCode', languageCode);

  String getCurrency() => _settingsBox.get('currencySymbol', defaultValue: r'$')!;
  void setCurrency({required String currencySymbol}) => _settingsBox.put('currencySymbol', currencySymbol);
}
