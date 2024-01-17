part of 'create_order_cubit.dart';

class CreateOrderState extends Equatable {
  const CreateOrderState({
    required this.status,
    required this.quantities,
  });

  const CreateOrderState.empty({required List<int>? quantities})
      : this(
          status: FormStatus.initial,
          quantities: quantities ?? const [],
        );

  final FormStatus status;
  final List<int> quantities;

  @override
  List<Object> get props => [
        status,
        quantities,
      ];

  CreateOrderState copyWith({
    FormStatus? status,
    List<int>? quantities,
  }) {
    return CreateOrderState(
      status: status ?? this.status,
      quantities: quantities ?? this.quantities,
    );
  }
}
