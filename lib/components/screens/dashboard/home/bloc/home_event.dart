part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ProductListEvent extends HomeEvent {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class ProductSearchListEvent extends HomeEvent {
  String? searchText;

  ProductSearchListEvent({this.searchText});

  @override
  List<Object?> get props => [searchText];
}
