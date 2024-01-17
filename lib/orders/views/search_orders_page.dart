import 'dart:developer';

import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:delivery_app/orders/widgets/orders_empty_list.dart';
import 'package:delivery_app/orders/widgets/orders_list_tile.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchOrdersPage extends StatefulWidget {
  const SearchOrdersPage({required this.orders, required this.foods, super.key});

  static String routeName = 'search_orders';
  static GoRoute route = GoRoute(
    name: routeName,
    path: 'searchOrders',
    builder: (context, state) {
      try {
        final orders = context.read<ListOrdersCubit>().state.orders;
        final foods = context.read<ListFoodCubit>().state.foods;

        return SearchOrdersPage(orders: orders, foods: foods);
      } catch (error) {
        log('Error - $error');
        return const SizedBox();
      }
    },
  );

  final List<Order> orders;
  final List<Food> foods;

  @override
  State<SearchOrdersPage> createState() => _SearchOrdersPageState();
}

class _SearchOrdersPageState extends State<SearchOrdersPage> {
  TextEditingController textEditingController = TextEditingController();
  List<Order> filteredOrders = <Order>[];

  @override
  void initState() {
    filteredOrders = widget.orders;
    super.initState();
  }

  void filterOrders(String query) {
    setState(() {
      filteredOrders = widget.orders
          .where(
            (order) =>
                order.name.toLowerCase().contains(query.toLowerCase()) ||
                order.items.any(
                  (orderItem) {
                    final matchingFood = widget.foods.firstWhere((food) => food.id == orderItem.foodId);
                    return matchingFood.name!.toLowerCase().contains(query.toLowerCase());
                  },
                ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: filterOrders,
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: l10n.search,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty ? const EmptyOrdersListView() : OrdersSearchList(filteredOrders: filteredOrders, widget: widget),
          ),
        ],
      ),
    );
  }
}

class OrdersSearchList extends StatelessWidget {
  const OrdersSearchList({
    required this.filteredOrders, required this.widget, super.key,
  });

  final List<Order> filteredOrders;
  final SearchOrdersPage widget;

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
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final sortedList = filteredOrders
          ..sort((item1, item2) => item2.createdAt!.compareTo(item2.createdAt!))
          ..reversed;
        return OrdersListTile(index: index, orders: sortedList, foods: widget.foods);
      },
    );
  }
}
