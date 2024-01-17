import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/create_order_page/cubit/create_order_cubit.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodsListView extends StatelessWidget {
  const FoodsListView({
    required this.foods,
    required this.size,
    required this.settingsCubit,
    required this.l10n,
    required this.createOrderCubit,
    super.key,
  });

  final List<Food> foods;
  final Size size;
  final SettingsCubit settingsCubit;
  final CreateOrderCubit createOrderCubit;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
      builder: (context, state) {
        return SizedBox(
          height: size.height * 0.7,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(thickness: 0.5, height: 0.5),
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(settingsCubit.getCurrencyFormattedText(value: foods[index].price! * state.quantities[index])),
                title: Text(foods[index].name ?? l10n.error),
                subtitle: Text('${foods[index].stock! - state.quantities[index]} ${l10n.units_left}'),
                trailing: TrailingWidget(
                  index: index,
                  createOrderCubit: createOrderCubit,
                  state: state,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class TrailingWidget extends StatelessWidget {
  const TrailingWidget({
    required this.index,
    required this.createOrderCubit,
    required this.state,
    super.key,
  });

  final int index;
  final CreateOrderCubit createOrderCubit;
  final CreateOrderState state;

  @override
  Widget build(BuildContext context) {
    final quantity = state.quantities[index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: quantity <= 0 ? null : () => createOrderCubit.decrement(index),
        ),
        const SizedBox(width: 5),
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 5),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: quantity >= 0 ? () => createOrderCubit.increment(index) : null,
        ),
      ],
    );
  }
}
