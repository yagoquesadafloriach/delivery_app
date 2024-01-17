import 'package:equatable/equatable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Language extends Equatable {
  const Language({
    required this.name,
    required this.code,
    required this.flagEmoji,
    required this.localeBuilder,
  });

  final String name;
  final String code;
  final String flagEmoji;
  final String Function(AppLocalizations l10n) localeBuilder;

  @override
  List<Object?> get props => [name, code, flagEmoji, localeBuilder];
}
