import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/prefs/user_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsLoadedAll extends ItemsState {
  final List<dynamic> itemsAll;
  ItemsLoadedAll(this.itemsAll);
}

class ItemsLoadedFilter extends ItemsState {
  final List<dynamic> itemsFilter;
  ItemsLoadedFilter(this.itemsFilter);
}

class ItemsError extends ItemsState {
  final String message;
  ItemsError(this.message);
}

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());
  String url = 'http://146.190.109.66:8000';

  void clearItems() {
    emit(ItemsLoadedAll([])); // Emit an empty list to clear the items displayed
  }

  Future<void> fetchItemsAll() async {
    emit(ItemsLoading());
    try {
      String? token = await getToken();
      var response = await http.get(
        Uri.parse(url + '/items/?skip=0&limit=100'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> items = jsonDecode(response.body);
        // print(response.body);
        emit(ItemsLoadedAll(items));
      } else {
        print(response.body);
        emit(ItemsError(
            'Failed to load items with status code ${response.statusCode}'));
      }
    } catch (e) {
      print(e);
      emit(ItemsError(
          'Error occurred while trying to load items: ${e.toString()}'));
    }
  }

  Future<void> fetchItemsFilter(String keyword) async {
    emit(ItemsLoading());
    try {
      String? token = await getToken(); // Your method to retrieve the token
      var response = await http.get(
        Uri.parse(url + '/search_items/' + keyword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> items = jsonDecode(response.body);
        // print(response.body);
        emit(ItemsLoadedFilter(items));
      } else {
        print(response.body);
        emit(ItemsError(
            'Failed to load items with status code ${response.statusCode}'));
      }
    } catch (e) {
      print(e);
      emit(ItemsError(
          'Error occurred while trying to load items: ${e.toString()}'));
    }
  }

  Future<Uint8List?> fetchImageData(int id) async {
    try {
      String? token = await getToken(); // Retrieve the token
      // Correct the URL to point directly to the image resource
      final response = await http.get(
        Uri.parse('http://146.190.109.66:8000/items_image/$id'), // Correct URL
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching image: $e');
      return null;
    }
  }
}
