import 'dart:developer';

import 'package:delivery_app/auth/data/auth_repository.dart';
import 'package:delivery_app/auth/signin/cubit/signin_cubit.dart';
import 'package:delivery_app/auth/signin/widgets/signin_form.dart';
import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/home/views/home_page.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  static String routeName = 'signin';
  static GoRoute route = GoRoute(
    name: routeName,
    path: '/signin',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: const SigninPage(),
        transitionDuration: const Duration(milliseconds: 2000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authRepository = context.read<AuthRepository>();

    return BlocProvider<SigninCubit>(
      create: (_) => SigninCubit(authRepository: authRepository, l10n: l10n),
      child: SigninView(l10n: l10n),
    );
  }
}

class SigninView extends StatelessWidget {
  const SigninView({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery App'.toUpperCase())),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocListener<SigninCubit, SigninState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            log('SignIn View - ${state.status}');
            return switch (state.status) {
              FormStatus.initial => log('isInitial ${state.status}'),
              FormStatus.success => context.goNamed(HomePage.routeName),
              FormStatus.error => _signinError(state, context),
              FormStatus.loading => log('isSubmitting ${state.status}'),
            };
          },
          child: const SigninForm(),
        ),
      ),
    );
  }

  Set<void> _signinError(SigninState state, BuildContext context) {
    return {
      log('isError ${state.status}'),
      if (state.errorMessage != null)
        {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Oh Snap!'),
              content: Text(state.errorMessage!),
            ),
          ),
        },
    };
  }
}
