import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EmptyOrdersListView extends StatelessWidget {
  const EmptyOrdersListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Text(
        l10n.no_order_placed,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
