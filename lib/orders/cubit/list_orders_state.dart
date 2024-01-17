part of 'list_orders_cubit.dart';

class ListOrderState extends Equatable {
  const ListOrderState({required this.orders, required this.status});

  const ListOrderState.empty() : this(orders: const [], status: FormStatus.initial);

  final FormStatus status;
  final List<Order> orders;

  @override
  List<Object> get props => [status, orders];

  ListOrderState copyWith({
    List<Order>? orders,
    FormStatus? status,
  }) {
    return ListOrderState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
    );
  }
}
