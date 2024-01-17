import 'package:flutter/material.dart';

class ListFoodError extends StatelessWidget {
  const ListFoodError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Error',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
