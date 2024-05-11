//Cart States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final dynamic cartItem;
  CartLoaded(this.cartItem);
}

class CartItemsFetched extends CartState {
  final List<dynamic> cartItems;
  CartItemsFetched(this.cartItems);
}

class CartError extends CartState {
  final String error;
  CartError(this.error);
}

class CartItemDeleted extends CartState {
  final int deletedCount;
  CartItemDeleted(this.deletedCount);
}
