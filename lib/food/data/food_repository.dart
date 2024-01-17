import 'package:delivery_app/food/data/firebase_food_service.dart';
import 'package:delivery_app/food/models/food_model.dart';

class FoodRepository {
  FoodRepository({required this.service});

  final FoodService service;

  Stream<List<Food>> streamFoodData() => service.streamFoodData();
}
