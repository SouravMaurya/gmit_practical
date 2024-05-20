part of 'home_bloc.dart';

class HomeState extends Equatable {
  bool? dataLoading;
  List<Product>? products;

  HomeState({this.dataLoading, this.products});

  HomeState copyWith({
    bool? dataLoading,
    List<Product>? products,
  }) {
    return HomeState(
      dataLoading: dataLoading ?? this.dataLoading,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [dataLoading, products];
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}
