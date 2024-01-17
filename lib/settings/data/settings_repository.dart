import 'dart:typed_data';

import 'package:delivery_app/settings/data/firebase_storage_service.dart';
import 'package:delivery_app/settings/data/hive_settings_service.dart';

class SettingsRepository {
  final HiveSettingsService _hiveSettingsService = HiveSettingsService();
  final FirebaseStorageService _firebaseStorageService = FirebaseStorageService();

  String? getLanguageCode() => _hiveSettingsService.getLanguageCode();
  void setLanguageCode({required String languageCode}) => _hiveSettingsService.setLanguageCode(languageCode: languageCode);

  String getCurrency() => _hiveSettingsService.getCurrency();
  void setCurrency({required String currencySymbol}) => _hiveSettingsService.setCurrency(currencySymbol: currencySymbol);

  Future<dynamic> getProfileImage({required String? userId}) => _firebaseStorageService.getProfileImage(userId: userId);
  Future<String> setProfileImage({required Uint8List imageBytes, required String userId}) =>
      _firebaseStorageService.setProfileImage(imageBytes: imageBytes, userId: userId);
}
