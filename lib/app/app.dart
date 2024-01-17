import 'package:delivery_app/app/view/app_view.dart';
import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/auth/data/auth_repository.dart';
import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/food/data/food_repository.dart';
import 'package:delivery_app/orders/create_order_page/cubit/create_order_cubit.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/orders/data/order_repository.dart';
import 'package:delivery_app/settings/cubit/settings_cubit.dart';
import 'package:delivery_app/settings/data/settings_repository.dart';
import 'package:delivery_app/settings/l10n/cubit/l10n_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({
    required this.authRepository,
    required this.foodRepository,
    required this.orderRepository,
    required this.settingsRepository,
    required this.router,
    super.key,
  });

  final AuthRepository authRepository;
  final FoodRepository foodRepository;
  final OrderRepository orderRepository;
  final SettingsRepository settingsRepository;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => authRepository),
        RepositoryProvider(create: (_) => foodRepository),
        RepositoryProvider(create: (_) => orderRepository),
        RepositoryProvider(create: (_) => settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepository: authRepository)),
          BlocProvider(create: (_) => ListFoodCubit(foodRepository: foodRepository)),
          BlocProvider(
            create: (_) => ListOrdersCubit(
              orderRepository: orderRepository,
              authBloc: AuthBloc(authRepository: authRepository),
            ),
          ),
          BlocProvider(
            create: (ctx) => CreateOrderCubit(
              orderRepository: orderRepository,
              authBloc: AuthBloc(authRepository: authRepository),
              listOrdersCubit: ctx.read<ListOrdersCubit>(),
              listFoodCubit: ctx.read<ListFoodCubit>(),
            ),
          ),
          BlocProvider(
            create: (_) => SettingsCubit(
              settingsRepository: settingsRepository,
              authBloc: AuthBloc(authRepository: authRepository),
            ),
          ),
          BlocProvider(
            create: (ctx) => L10nCubit(
              lenguageCode: WidgetsBinding.instance.platformDispatcher.locale.languageCode,
              settingsCubit: ctx.read<SettingsCubit>(),
            ),
          ),
        ],
        child: AppView(router: router),
      ),
    );
  }
}
