import 'package:delivery_app/auth/signin/cubit/signin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final signinCubit = context.read<SigninCubit>();

    return TextField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'email'),
      keyboardType: TextInputType.emailAddress,
      onChanged: signinCubit.emailChanged,
    );
  }
}
