import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/orders/models/order_item_model/order_item_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class Order extends Equatable {
  const Order({
    required this.name,
    required this.items,
    this.id,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  factory Order.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    final itemsData = data['items'] as List<dynamic>;
    final orderItems = itemsData.map((dynamic itemData) {
      final item = itemData as Map<String, dynamic>;

      return OrderItem(
        foodId: item['foodId'] as String,
        quantities: item['quantities'] as int,
      );
    }).toList();

    return Order(
      id: doc.id,
      name: data['name'] as String,
      createdAt: DateTime.now(),
      items: orderItems,
    );
  }

  final String? id;
  final String name;
  final DateTime? createdAt;
  final List<OrderItem> items;

  static const empty = Order(
    name: '',
    items: [],
  );

  bool get isEmpty => this == Order.empty;
  bool get isNotEmpty => this != Order.empty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, createdAt, items];
}
