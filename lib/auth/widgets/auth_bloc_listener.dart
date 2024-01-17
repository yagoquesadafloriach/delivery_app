import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/auth/signin/views/signin_page.dart';
import 'package:delivery_app/home/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthListener extends StatefulWidget {
  const AuthListener({required this.router, required this.child, super.key, this.executeAtInit = true});

  final GoRouter router;
  final Widget child;
  final bool executeAtInit;

  @override
  State<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener> {
  @override
  void initState() {
    super.initState();
    if (widget.executeAtInit) {
      Future.delayed(
        Duration.zero,
        () => listener(
          widget.router,
          context.read<AuthBloc>().state,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) => listener(widget.router, state),
      child: widget.child,
    );
  }

  void listener(GoRouter router, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        router.goNamed(HomePage.routeName);
      case AuthStatus.unauthenticated:
        router.goNamed(SigninPage.routeName);
      case AuthStatus.unknown:
        break;
    }
  }
}
