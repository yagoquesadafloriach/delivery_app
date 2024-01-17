import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/auth/models/user_model.dart';
import 'package:delivery_app/settings/constants/currencies.dart';
import 'package:delivery_app/settings/constants/languages.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/cubit/l10n_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:delivery_app/settings/profile_picture/views/profile_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final currentLanguageCode = context.read<L10nCubit>().languageCode;
    final currentCurrency = context.select<SettingsCubit, String>((cubit) => cubit.state.currencySymbol);
    final l10n = context.l10n;

    return Column(
      children: [
        const Spacer(),
        const ProfilePicture(),
        const SizedBox(height: 60),
        ElevatedButton(
          onPressed: () => _currencyBottomSheet(context: context, currentCurrency: currentCurrency),
          child: Text(l10n.select_currency),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _lenguageBottomSheet(context: context, currentLanguageCode: currentLanguageCode),
          child: Text(l10n.change_language),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _logoutDialog(context: context, l10n: l10n),
          style: const ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.redAccent)),
          child: Text(l10n.log_out),
        ),
        const Spacer(flex: 3),
      ],
    );
  }

  Future<dynamic> _logoutDialog({required BuildContext context, required AppLocalizations l10n}) {
    final authBloc = context.read<AuthBloc>();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.log_out),
          content: Text(l10n.sure_log_out),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.no),
            ),
            ElevatedButton(
              onPressed: () {
                authBloc.add(const AuthLogoutRequested());
                Navigator.of(context).pop();
              },
              child: Text(l10n.yes),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _lenguageBottomSheet({required BuildContext context, required String currentLanguageCode}) async {
    final l10nCubit = context.read<L10nCubit>();
    final resp = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(thickness: 0.5, height: 0.5),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return ListTile(
                onTap: () => Navigator.of(context).pop(language.code),
                horizontalTitleGap: 10,
                leading: Text(
                  language.flagEmoji,
                  style: const TextStyle(fontSize: 30),
                ),
                title: Text(language.name),
                tileColor: currentLanguageCode == language.code ? Colors.deepPurpleAccent : null,
              );
            },
          ),
        );
      },
    );

    if (resp == null) return;
    l10nCubit.changeLocale(languageCode: resp);
  }

  Future<dynamic> _currencyBottomSheet({required BuildContext context, required String currentCurrency}) async {
    final settingsCubit = context.read<SettingsCubit>();
    final resp = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              thickness: 0.5,
              height: 0.5,
            ),
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return ListTile(
                onTap: () => Navigator.of(context).pop(currency.symbol),
                horizontalTitleGap: 10,
                leading: Text(
                  currency.symbol,
                  style: const TextStyle(fontSize: 30),
                ),
                title: Text(currency.name),
                tileColor: currentCurrency == currency.symbol ? Colors.deepPurpleAccent : null,
              );
            },
          ),
        );
      },
    );

    if (resp == null) return;
    settingsCubit.changeCurrency(currencySymbol: resp);
  }
}
