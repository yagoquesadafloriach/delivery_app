import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/orders/widgets/orders_error.dart';
import 'package:delivery_app/orders/widgets/orders_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final listFoodCubit = context.read<ListFoodCubit>();

    return BlocBuilder<ListOrdersCubit, ListOrderState>(
      builder: (context, state) {
        return switch (state.status) {
          FormStatus.success => OrdersSuccess(orders: state.orders, foods: listFoodCubit.state.foods),
          FormStatus.error => const OrdersError(),
          FormStatus.loading => const Center(child: CircularProgressIndicator()),
          _ => const SizedBox(),
        };
      },
    );
  }
}
