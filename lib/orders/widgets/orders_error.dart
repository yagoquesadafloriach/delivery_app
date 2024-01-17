import 'package:flutter/material.dart';

class OrdersError extends StatelessWidget {
  const OrdersError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error',
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}
