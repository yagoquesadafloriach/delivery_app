import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/common/enums/form_status.dart';
import 'package:delivery_app/food/data/food_repository.dart';
import 'package:delivery_app/food/models/food_model.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

part 'list_food_state.dart';

class ListFoodCubit extends Cubit<ListFoodState> {
  ListFoodCubit({required this.foodRepository}) : super(const ListFoodState.empty()) {
    _getListFood();
  }

  final FoodRepository foodRepository;

  StreamSubscription<List<Food>>? _subscription;

  void _getListFood() {
    try {
      emit(state.copyWith(status: FormStatus.loading));

      final foodStream = foodRepository.streamFoodData();

      _subscription?.cancel();

      _subscription = foodStream.listen(
        (foodList) => emit(state.copyWith(status: FormStatus.success, foods: foodList)),
        onError: (dynamic error) {
          log('Error in stream - $error');
          emit(state.copyWith(status: FormStatus.error));
        },
      );
    } on FirebaseException catch (e) {
      log('Firebase Error - $e');
      emit(state.copyWith(status: FormStatus.error));
    } catch (error) {
      log('Error - $error');
      emit(state.copyWith(status: FormStatus.error));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
