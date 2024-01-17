import 'package:delivery_app/app/app.dart';
import 'package:delivery_app/auth/data/auth_repository.dart';
import 'package:delivery_app/bloc_observer.dart';
import 'package:delivery_app/firebase_options.dart';
import 'package:delivery_app/food/data/firebase_food_service.dart';
import 'package:delivery_app/food/data/food_repository.dart';
import 'package:delivery_app/orders/data/firebase_order_service.dart';
import 'package:delivery_app/orders/data/order_repository.dart';
import 'package:delivery_app/router/router.dart';
import 'package:delivery_app/settings/data/settings_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Hive
  await Hive.initFlutter();
  await Hive.openBox<String>('settings');

  /// BLoC
  final authRepository = AuthRepository();
  final foodRepository = FoodRepository(service: FoodService());
  final orderRepository = OrderRepository(service: FirebaseOrderService());
  final settingsRepository = SettingsRepository();

  Bloc.observer = AppBlocObserver();

  /// GO Router
  final router = RouterBuilder.buildRouter();

  /// runApp
  runApp(
    App(
      authRepository: authRepository,
      foodRepository: foodRepository,
      orderRepository: orderRepository,
      settingsRepository: settingsRepository,
      router: router,
    ),
  );
}
