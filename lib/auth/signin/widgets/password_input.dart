import 'package:delivery_app/auth/signin/cubit/signin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({required this.controller, super.key, this.textFieldPasswordFilled = false});

  final TextEditingController controller;
  final bool textFieldPasswordFilled;

  @override
  Widget build(BuildContext context) {
    final signinCubit = context.read<SigninCubit>();

    return TextField(
      onChanged: signinCubit.passwordChanged,
      controller: controller,
      decoration: const InputDecoration(labelText: 'password'),
      obscureText: true,
    );
  }
}
