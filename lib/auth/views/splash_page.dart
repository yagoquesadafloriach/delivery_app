import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static String routeName = 'splash';
  static GoRoute route = GoRoute(
    name: routeName,
    path: '/splash',
    builder: (context, state) {
      return const SplashPage();
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Delivery App',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
