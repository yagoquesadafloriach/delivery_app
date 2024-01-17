import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItem extends Equatable {
  const OrderItem({
    required this.foodId,
    required this.quantities,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

  OrderItem.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : foodId = doc.id,
        quantities = doc.data()!['quantities'] as int;
  final String foodId;
  final int quantities;

  static const empty = OrderItem(
    foodId: '',
    quantities: 0,
  );

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  @override
  List<Object?> get props => [foodId, quantities];
}
