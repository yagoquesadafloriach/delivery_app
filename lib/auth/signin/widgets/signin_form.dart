import 'package:delivery_app/auth/signin/widgets/email_input.dart';
import 'package:delivery_app/auth/signin/widgets/password_input.dart';
import 'package:delivery_app/auth/signin/widgets/signin_button.dart';
import 'package:flutter/material.dart';

class SigninForm extends StatelessWidget {
  const SigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EmailInput(controller: emailController),
        const SizedBox(height: 8),
        PasswordInput(controller: passwordController),
        const SizedBox(height: 8),
        SigninButton(
          emailController: emailController,
          passwordController: passwordController,
          isSignIn: true,
        ),
        const SizedBox(height: 8),
        SigninButton(
          emailController: emailController,
          passwordController: passwordController,
        ),
      ],
    );
  }
}
