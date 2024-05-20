import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gmit_practical/app/model/dashboard/product_list_resp_model.dart';
import 'package:gmit_practical/components/screens/dashboard/home/bloc/repository/home_repo.dart';
import 'package:gmit_practical/main.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository = HomeRepository();

  HomeBloc() : super(HomeInitial()) {
    on<ProductListEvent>(onHomeListEvent);
    on<ProductSearchListEvent>(onProductSearchListEvent);
  }

  Future<void> onHomeListEvent(
      ProductListEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(dataLoading: true));
    try {
      ProductListResponse? productListResponse = await homeRepository
          .getProducts(globalNavigationKey.currentState!.context);
      if (productListResponse != null) {
        emit(state.copyWith(
            dataLoading: false, products: productListResponse.products));
      }
    } catch (e) {
      emit(state.copyWith(dataLoading: false));
    }
  }

  Future<void> onProductSearchListEvent(
      ProductSearchListEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(dataLoading: true));
    try {
      ProductListResponse? productListResponse = await homeRepository
          .getSearchProducts(globalNavigationKey.currentState!.context,
              searchText: event.searchText);
      if (productListResponse != null) {
        emit(state.copyWith(
            dataLoading: false, products: productListResponse.products));
      }
    } catch (e) {
      emit(state.copyWith(dataLoading: false));
    }
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
    debugPrint("HomeBloc Event ---> ${transition.event}");
    debugPrint("HomeBloc CurrentState ---> ${transition.currentState}");
    debugPrint("HomeBloc NextState ---> ${transition.nextState}");
  }
}
