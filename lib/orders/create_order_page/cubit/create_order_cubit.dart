import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/food/cubit/list_food_cubit.dart';
import 'package:delivery_app/food/models/food_model.dart';
import 'package:delivery_app/orders/cubit/list_orders_cubit.dart';
import 'package:delivery_app/orders/data/order_repository.dart';
import 'package:delivery_app/orders/models/order_item_model/order_item_model.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  CreateOrderCubit({required this.orderRepository, required this.authBloc, required this.listOrdersCubit, required this.listFoodCubit})
      : super(CreateOrderState.empty(quantities: List<int>.generate(listFoodCubit.state.foods.length, (index) => 0)));

  final OrderRepository orderRepository;
  final AuthBloc authBloc;
  final ListOrdersCubit listOrdersCubit;
  final ListFoodCubit listFoodCubit;

  Future<void> submitOrder({required List<Food>? foods}) async {
    final randomName = 'Order - ${DateTime.now().millisecondsSinceEpoch} - ${math.Random().nextInt(10000)}';

    final newOrder = Order(
      name: randomName,
      items: _getItems(foods: foods),
      createdAt: DateTime.now(),
    );

    try {
      if (authBloc.userId == null || authBloc.userId!.isEmpty) {
        log('Error user is empty or null');
        return;
      }

      await _addOrderData(order: newOrder);
      _resetAllToZero();
    } catch (error) {
      log('Error - $error');
      return;
    }
  }

  Future<void> _addOrderData({required Order order}) async {
    try {
      emit(state.copyWith(status: FormStatus.loading));
      await orderRepository.addOrderData(order: order, userId: authBloc.userId!);
      emit(state.copyWith(status: FormStatus.success));
      listOrdersCubit.getListOrders();
    } on FirebaseException {
      log('FirebaseException Error');
      emit(state.copyWith(status: FormStatus.error));
    } catch (error) {
      log('Unknown Error - $error');
      emit(state.copyWith(status: FormStatus.error));
    }
  }

  List<OrderItem> _getItems({required List<Food>? foods}) {
    final orderItems = <OrderItem>[];
    final quantities = state.quantities;

    for (var i = 0; i < foods!.length; i++) {
      if (quantities[i] > 0) {
        orderItems.add(OrderItem(foodId: foods[i].id, quantities: quantities[i]));
      }
    }

    return orderItems;
  }

  void _resetAllToZero() {
    final resetQuantities = List<int>.filled(state.quantities.length, 0);
    emit(state.copyWith(quantities: resetQuantities));
  }

  void increment(int index) {
    final updatedQuantities = List<int>.from(state.quantities);
    log(updatedQuantities.toString());
    updatedQuantities[index]++;
    emit(state.copyWith(quantities: updatedQuantities));
  }

  void decrement(int index) {
    final updatedQuantities = List<int>.from(state.quantities);
    updatedQuantities[index]--;
    emit(state.copyWith(quantities: updatedQuantities));
  }

  double calculateTotal({required List<Food>? foods}) {
    final quantities = state.quantities;

    if (foods == null || foods.isEmpty || state.quantities.length != foods.length) {
      return 0;
    }

    var totalValue = 0.0;

    for (var i = 0; i < foods.length; i++) {
      totalValue += foods[i].price! * quantities[i];
    }

    return totalValue;
  }

  bool isEmpty() {
    var number = 0;

    for (final num in state.quantities) {
      number += num;
    }

    if (number == 0 || number.isNaN) return true;

    return false;
  }
}
