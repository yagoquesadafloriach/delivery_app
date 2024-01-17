import 'package:delivery_app/auth/signin/cubit/signin_cubit.dart';
import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninButton extends StatelessWidget {
  const SigninButton({required this.emailController, required this.passwordController, super.key, this.isSignIn = false});

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    final signinCubit = context.read<SigninCubit>();
    final l10n = context.l10n;

    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ValueListenableBuilder(
          valueListenable: passwordController,
          builder: (context, password, child) {
            return ValueListenableBuilder(
              valueListenable: emailController,
              builder: (context, email, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                    backgroundColor: email.text.isEmpty || password.text.isEmpty ? null : Colors.deepPurpleAccent,
                  ),
                  onPressed: state.status == FormStatus.loading || email.text.isEmpty || password.text.isEmpty
                      ? null
                      : () => signinCubit.signin(isSignIn: isSignIn),
                  child: Text(
                    state.status == FormStatus.loading
                        ? 'LOADING...'
                        : isSignIn
                            ? l10n.sign_in.toUpperCase()
                            : l10n.sign_up.toUpperCase(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
