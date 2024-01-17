import 'package:delivery_app/orders/data/firebase_order_service.dart';

import 'package:delivery_app/orders/models/order_model/order_model.dart' as model;

class OrderRepository {
  OrderRepository({required this.service});

  final FirebaseOrderService service;

  // Future<void> retrieveOrderData({required String userId}) => service.retrieveOrderData(userId: userId);

  Future<void> addOrderData({required model.Order order, required String userId}) => service.addOrderData(order: order, userId: userId);

  Future<void> deleteOrderData({required String orderId, required String userId}) =>
      service.deleteOrderData(orderId: orderId, userId: userId);

  Stream<List<model.Order>> streamOrderData({required String userId}) => service.streamOrderData(userId: userId);

  Stream<List<model.Order>> get orderStream => service.orderStream;
}
