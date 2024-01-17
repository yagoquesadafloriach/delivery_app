import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/food/models/food_model.dart';

class FoodService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _foodCollection = _firestore.collection('food');

  Stream<List<Food>> streamFoodData() {
    try {
      return _foodCollection.snapshots().asyncMap((snapshot) async => snapshot.docs.map(Food.fromDocumentSnapshot).toList());
    } catch (error) {
      log('Error - $error');
      rethrow;
    }
  }
}
