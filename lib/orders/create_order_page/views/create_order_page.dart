import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/create_order_page/cubit/create_order_cubit.dart';
import 'package:delivery_app/orders/create_order_page/widgets/foods_list_view.dart';
import 'package:delivery_app/orders/create_order_page/widgets/order_footer.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({required this.foods, super.key});

  final List<Food> foods;

  static String routeName = 'create_order';
  static GoRoute route = GoRoute(
    name: routeName,
    path: 'createOrder',
    builder: (context, state) {
      final foods = context.read<ListFoodCubit>().state.foods;

      return CreateOrderPage(foods: foods);
    },
  );

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = context.l10n;

    return CreateOrderView(
      widget: widget,
      size: size,
      l10n: l10n,
    );
  }
}

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({
    required this.widget, required this.size, required this.l10n, super.key,
  });

  final CreateOrderPage widget;
  final Size size;
  final AppLocalizations l10n;

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  late final CreateOrderCubit _createOrderCubit;
  late final SettingsCubit _settingsCubit;

  late final List<dynamic> quantities;

  @override
  void initState() {
    super.initState();
    _createOrderCubit = context.read<CreateOrderCubit>();
    _settingsCubit = context.read<SettingsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Spacer(),
          FoodsListView(
            foods: widget.widget.foods,
            size: widget.size,
            l10n: widget.l10n,
            settingsCubit: _settingsCubit,
            createOrderCubit: _createOrderCubit,
          ),
          OrderFooter(
            foods: widget.widget.foods,
            l10n: widget.l10n,
            settingsCubit: _settingsCubit,
            createOrderCubit: _createOrderCubit,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
