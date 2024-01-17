import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/food/views/widgets/list_food_error.dart';
import 'package:delivery_app/food/views/widgets/list_food_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListFoodPage extends StatelessWidget {
  const ListFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListFoodCubit, ListFoodState>(
      builder: (context, state) {
        return switch (state.status) {
          FormStatus.success => ListFoodSuccess(foods: state.foods),
          FormStatus.error => const ListFoodError(),
          FormStatus.loading => const Center(child: CircularProgressIndicator()),
          _ => const SizedBox()
        };
      },
    );
  }
}
