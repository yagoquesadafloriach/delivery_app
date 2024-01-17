import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:delivery_app/settings/models/language.dart';

List<Language> languages = [
  Language(name: 'English', flagEmoji: '🇺🇸', code: 'en', localeBuilder: (AppLocalizations l10n) => l10n.english),
  Language(name: 'Spanish', flagEmoji: '🇪🇸', code: 'es', localeBuilder: (AppLocalizations l10n) => l10n.spanish),
];
