import 'package:delivery_app/auth/widgets/auth_bloc_listener.dart';
import 'package:delivery_app/settings/l10n/cubit/l10n_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AppView extends StatelessWidget {
  const AppView({
    required this.router,
    super.key,
  });

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<L10nCubit, Locale, Locale>(
      selector: (state) => state,
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          title: 'Delivery App',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state,
          builder: (context, child) => AuthListener(router: router, child: child!),
        );
      },
    );
  }
}
