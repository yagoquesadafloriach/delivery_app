import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:delivery_app/orders/widgets/orders_empty_list.dart';
import 'package:delivery_app/orders/widgets/orders_list_tile.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({
    required this.orders, required this.foods, super.key,
  });

  final List<Order> orders;
  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty ? const EmptyOrdersListView() : OrderssListView(orders: orders, foods: foods);
  }
}

class OrderssListView extends StatelessWidget {
  const OrderssListView({
    required this.orders, required this.foods, super.key,
  });

  final List<Order> orders;
  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 0.5,
        height: 0.5,
      ),
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final sortedList = orders
          ..sort((item1, item2) => item2.createdAt!.compareTo(item2.createdAt!))
          ..reversed;
        return OrdersListTile(index: index, orders: sortedList, foods: foods);
      },
    );
  }
}
