import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/create_order_page/views/create_order_page.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:delivery_app/orders/views/search_orders_page.dart';
import 'package:delivery_app/orders/widgets/orders_list.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrdersSuccess extends StatelessWidget {
  const OrdersSuccess({
    required this.orders, required this.foods, super.key,
  });

  final List<Order> orders;
  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: orders.isEmpty ? null : () => context.pushNamed(SearchOrdersPage.routeName),
              child: Text(l10n.search_order),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: orders.isEmpty ? Colors.deepPurpleAccent : null),
              onPressed: () => context.pushNamed(CreateOrderPage.routeName),
              child: Text(l10n.create_new_order),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: size.height * 0.7,
            child: OrdersList(orders: orders, foods: foods),
          ),
        ),
      ],
    );
  }
}
