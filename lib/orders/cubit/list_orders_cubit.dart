import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/auth/blocs/auth_bloc.dart';
import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/orders/data/order_repository.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'list_orders_state.dart';

class ListOrdersCubit extends Cubit<ListOrderState> {
  ListOrdersCubit({required this.orderRepository, required this.authBloc}) : super(const ListOrderState.empty()) {
    _authSubscription = authBloc.authStream.listen(
      (event) {
        if (!event.isAuthenticated) {
          emit(const ListOrderState.empty());
        } else {
          getListOrders();
        }
      },
    );

    if (authBloc.state.isAuthenticated) {
      getListOrders();
    }
  }

  final OrderRepository orderRepository;
  final AuthBloc authBloc;

  late StreamSubscription<AuthState> _authSubscription;
  StreamSubscription<List<Order>>? _orderSubscription;

  void getListOrders() {
    try {
      emit(state.copyWith(status: FormStatus.loading));

      final ordersStream = orderRepository.streamOrderData(userId: authBloc.userId!);

      _orderSubscription?.cancel();

      _orderSubscription = ordersStream.listen(
        (orderList) => emit(state.copyWith(status: FormStatus.success, orders: orderList)),
        onError: (dynamic error) {
          log('Error in stream - $error');
          emit(state.copyWith(status: FormStatus.error));
        },
      );
    } on FirebaseException {
      log('FirebaseException Error');
      emit(state.copyWith(status: FormStatus.error));
    } catch (error) {
      log('Unknown Error - $error');
      emit(state.copyWith(status: FormStatus.error));
    }
  }

  Future<void> deleteOrderData({required String orderId}) async {
    try {
      emit(state.copyWith(status: FormStatus.loading));
      await orderRepository.deleteOrderData(orderId: orderId, userId: authBloc.userId!);
      emit(state.copyWith(status: FormStatus.success));
      getListOrders();
    } on FirebaseException {
      log('FirebaseException Error');
      emit(state.copyWith(status: FormStatus.error));
    } catch (error) {
      log('Unknown Error - $error');
      emit(state.copyWith(status: FormStatus.error));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _orderSubscription?.cancel();
    return super.close();
  }
}
