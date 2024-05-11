import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/prefs/user_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Cart States
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

// Cart Cubit
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final String baseUrl = 'http://146.190.109.66:8000';
  Future<void> clearWholeCartByUserId() async {
    String? token = await getToken();
    int? userId = await getUserId();
    emit(CartLoading());
    try {
      http.Response response = await http.delete(
        Uri.parse('$baseUrl/clear_whole_carts_by_userid/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        emit(CartItemDeleted(data['record_dihapus']));
      } else {
        emit(CartError(
            'Failed to clear whole cart with status code ${response.statusCode}'));
      }
    } catch (e) {
      emit(CartError('Failed to clear whole cart: $e'));
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    String? token = await getToken();
    emit(CartLoading()); // Indicates the start of a deletion process
    try {
      http.Response response = await http.delete(
        Uri.parse('$baseUrl/carts/$cartId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // After a successful deletion, refetch the cart items to update the list
        fetchCartItems();
      } else {
        emit(CartError(
            'Failed to delete cart item with status code ${response.statusCode}'));
      }
    } catch (e) {
      emit(CartError('Failed to delete cart item: $e'));
    }
  }

  Future<void> fetchCartItems() async {
    String? token = await getToken();
    int? userId = await getUserId();
    emit(CartLoading());
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/carts/$userId?skip=0&limit=100'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> cartItems = jsonDecode(response.body);
        emit(CartItemsFetched(cartItems)); // Ensure this is being called
      } else {
        emit(CartError(
            'Failed to fetch cart items with status code ${response.statusCode}'));
      }
    } catch (e) {
      emit(CartError('Failed to fetch cart items: $e'));
    }
  }

  Future<void> addToCart(int itemId, int quantity) async {
    String? token = await getToken();
    int? userId = await getUserId();
    emit(CartLoading());
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/carts/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'item_id': itemId,
          'user_id': userId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        dynamic cartItem = jsonDecode(response.body);
        emit(CartLoaded(cartItem));
      } else {
        emit(CartError(
            'Failed to add item to cart with status code ${response.statusCode}'));
      }
    } catch (e) {
      emit(CartError('Failed to add item to cart: $e'));
    }
  }
}
