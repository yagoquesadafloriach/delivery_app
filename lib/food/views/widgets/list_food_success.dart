import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/food/views/widgets/food_tile_leading.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListFoodSuccess extends StatelessWidget {
  const ListFoodSuccess({required this.foods, super.key});

  final List<Food> foods;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(thickness: 0.5, height: 0.5),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      itemCount: foods.length,
      itemBuilder: (context, index) => ListFoodTile(foods: foods, index: index),
    );
  }
}

class ListFoodTile extends StatelessWidget {
  const ListFoodTile({required this.foods, required this.index, super.key});

  final List<Food> foods;
  final int index;

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final l10n = context.l10n;

    return ListTile(
      leading: FoodTileLeading(url: foods[index].photo),
      title: Text(foods[index].name ?? l10n.error),
      subtitle: Text('${foods[index].stock} ${l10n.units_left}'),
      trailing: Text('${settingsCubit.getCurrencyFormattedText(value: foods[index].price!)} / ${l10n.unit}'),
    );
  }
}
