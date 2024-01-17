part of 'list_food_cubit.dart';

class ListFoodState extends Equatable {
  const ListFoodState({required this.foods, required this.status});

  const ListFoodState.empty() : this(foods: const [], status: FormStatus.initial);

  final FormStatus status;
  final List<Food> foods;

  @override
  List<Object> get props => [status, foods];

  ListFoodState copyWith({
    List<Food>? foods,
    FormStatus? status,
  }) {
    return ListFoodState(
      foods: foods ?? this.foods,
      status: status ?? this.status,
    );
  }
}
