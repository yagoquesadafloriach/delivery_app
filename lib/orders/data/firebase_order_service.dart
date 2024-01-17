import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/orders/models/order_model/order_model.dart' as model;

class FirebaseOrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _userCollection = _firestore.collection('user');

  final StreamController<List<model.Order>> _orderStreamController = StreamController<List<model.Order>>.broadcast();

  Stream<List<model.Order>> get orderStream => _orderStreamController.stream;

  // Future<void> retrieveOrderData({required String userId}) async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await _userCollection.doc(userId).collection('order').get();

  //     if (snapshot.docs.isEmpty) {
  //       log('No orders found for user $userId.');
  //       _orderStreamController.add([]);
  //       return;
  //     }

  //     List<model.Order> orders = snapshot.docs.map((snapshots) => model.Order.fromDocumentSnapshot(snapshots)).toList();
  //     _orderStreamController.add(orders);
  //   } catch (error) {
  //     log('Error - $error');
  //     _orderStreamController.add([]);
  //   }
  // }

  Stream<List<model.Order>> streamOrderData({required String userId}) {
    try {
      return _userCollection.doc(userId).collection('order').snapshots().asyncMap((snapshot) async {
        final orders = await Future.wait(
          snapshot.docs.map((document) async {
            return model.Order.fromDocumentSnapshot(document);
          }),
        );
        return orders;
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrderData({required model.Order order, required String userId}) async {
    try {
      await _userCollection.doc(userId).collection('order').doc(order.name).set(order.toJson());
    } catch (error) {
      log('Error - $error');
    }
  }

  Future<void> deleteOrderData({required String orderId, required String userId}) async {
    try {
      await _userCollection.doc(userId).collection('order').doc(orderId).delete();
    } catch (error) {
      log('Error - $error');
    }
  }

  void dispose() {
    _orderStreamController.close();
  }
}
