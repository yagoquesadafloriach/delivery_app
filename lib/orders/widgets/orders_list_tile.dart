import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:delivery_app/orders/views/order_details_page.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class OrdersListTile extends StatelessWidget {
  const OrdersListTile({
    required this.index,
    required this.orders,
    required this.foods,
    super.key,
  });

  final int index;
  final List<Order> orders;
  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final l10n = context.l10n;

    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: _onPressedSlide,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever,
            label: 'Delete',
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(orders[index].name),
          subtitle: Text(
            '${l10n.created}: ${orders[index].createdAt.toString().substring(0, 10)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(settingsCubit.getCurrencyFormattedText(value: _calculateTotal(index))),
          onTap: () => context.pushNamed(
            OrderDetailsPage.routeName,
            pathParameters: {'id': orders[index].id ?? ''},
          ),
        ),
      ),
    );
  }

  Future<void> _onPressedSlide(BuildContext context) async {
    final listOrdersCubit = context.read<ListOrdersCubit>();
    await listOrdersCubit.deleteOrderData(orderId: orders[index].name);
  }

  double _calculateTotal(int index) {
    var totalPrice = 0.0;

    if (index < 0 && index >= orders.length) return 0;

    for (final orderItem in orders[index].items) {
      final food = foods.firstWhere(
        (food) => food.id == orderItem.foodId,
        orElse: () => Food.empty,
      );

      if (food.isNotEmpty) totalPrice += food.price! * orderItem.quantities;
    }

    return double.parse(totalPrice.toStringAsFixed(2));
  }
}
