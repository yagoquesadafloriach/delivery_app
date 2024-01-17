import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/constants/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_model.g.dart';

@JsonSerializable()
class Food extends Equatable {
  const Food({
    required this.id,
    this.name,
    this.photo,
    this.stock,
    this.price,
  });

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  factory Food.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) => Food.fromJson({...doc.data()!, 'id': doc.id});

  final String id;
  final String? name;
  final String? photo;
  final int? stock;
  final double? price;

  static const empty = Food(
    id: '',
    name: '',
    photo: noFoodImage,
    stock: 0,
    price: 0,
  );

  bool get isEmpty => this == Food.empty;
  bool get isNotEmpty => this != Food.empty;

  Map<String, dynamic> toJson() => _$FoodToJson(this);

  @override
  List<Object?> get props => [name, photo, stock, price];
}
