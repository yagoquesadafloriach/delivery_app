import 'dart:developer';

import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/food/views/widgets/food_tile_leading.dart';
import 'package:delivery_app/home/views/home_page.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:delivery_app/pdf/pdf_service.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({required this.order, required this.foods, super.key});

  final Order order;
  final List<Food> foods;

  static String routeName = 'order_details';
  static GoRoute route = GoRoute(
    name: routeName,
    path: 'orderDetails/:id',
    builder: (context, state) {
      try {
        final id = state.pathParameters['id'] ?? '';
        final orders = context.read<ListOrdersCubit>().state.orders;
        final foods = context.read<ListFoodCubit>().state.foods;

        final order = orders.firstWhere(
          (element) => element.id == id,
          orElse: () => Order.empty,
        );

        if (order.isEmpty) return const HomePage();

        return OrderDetailsPage(
          order: order,
          foods: foods,
        );
      } catch (error) {
        log('Error - $error');
        return const HomePage();
      }
    },
  );

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = context.l10n;
    final settingsCubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          _titleHeader(context),
          const SizedBox(height: 20),
          SizedBox(
            height: size.height * 0.5,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(thickness: 0.5, height: 0.5),
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              itemCount: widget.order.items.length,
              itemBuilder: (BuildContext context, int index) {
                final food = widget.foods.firstWhere(
                  (element) => element.id == widget.order.items[index].foodId,
                  orElse: () => Food.empty,
                );

                if (food.isEmpty) return const SizedBox();

                return ListTile(
                  leading: FoodTileLeading(url: food.photo),
                  trailing: Text(widget.order.items[index].quantities.toString()),
                  title: Text(food.name ?? ''),
                  subtitle: Text('${settingsCubit.getCurrencyFormattedText(value: food.price!)} / ${l10n.unit}'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _totalPrice(l10n, settingsCubit, context),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final pdfFile = await PdfService.generate(
                order: widget.order,
                foods: widget.foods,
                buildContext: context,
              );

              await PdfService.openFile(pdfFile);
            },
            child: Text(l10n.generate_pdf),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Text _totalPrice(AppLocalizations l10n, SettingsCubit settingsCubit, BuildContext context) {
    return Text(
      '${l10n.total} ${settingsCubit.getCurrencyFormattedText(value: _calculateTotal(widget.foods))}',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Text _titleHeader(BuildContext context) {
    return Text(
      widget.order.name,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  double _calculateTotal(List<Food> foodList) {
    var totalPrice = 0.0;

    for (final orderItem in widget.order.items) {
      final food = foodList.firstWhere(
        (food) => food.id == orderItem.foodId,
        orElse: () => Food.empty,
      );

      if (food.isNotEmpty) totalPrice += food.price! * orderItem.quantities;
    }

    return double.parse(totalPrice.toStringAsFixed(2));
  }
}
