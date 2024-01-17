import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/create_order_page/cubit/create_order_cubit.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderFooter extends StatelessWidget {
  const OrderFooter({
    required this.l10n, required this.settingsCubit, required this.foods, required this.createOrderCubit, super.key,
  });

  final AppLocalizations l10n;
  final SettingsCubit settingsCubit;
  final CreateOrderCubit createOrderCubit;
  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
      builder: (context, state) {
        final total = createOrderCubit.calculateTotal(foods: foods);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${l10n.total} ${settingsCubit.getCurrencyFormattedText(value: total)}'),
            ElevatedButton(
              onPressed: createOrderCubit.isEmpty()
                  ? null
                  : () => _confirmOrderDialog(context: context, l10n: l10n, createOrderCubit: createOrderCubit),
              child: Text(l10n.save_proceed),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmOrderDialog({
    required BuildContext context,
    required AppLocalizations l10n,
    required CreateOrderCubit createOrderCubit,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.place_order),
          content: Text(l10n.sure_to_place_order),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.no),
            ),
            BlocBuilder<ListOrdersCubit, ListOrderState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    createOrderCubit.submitOrder(foods: foods);

                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  child: Text(l10n.yes),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
