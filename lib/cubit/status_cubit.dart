import 'package:bloc/bloc.dart';
import 'package:food_delivery_app/prefs/user_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class StatusState {}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final dynamic status;
  StatusLoaded(this.status);
}

class StatusError extends StatusState {
  final String message;
  StatusError(this.message);
}

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusInitial());
  final String baseUrl = 'http://146.190.109.66:8000';

  Future<void> fetchStatus() async {
    emit(StatusLoading());
    String? token =
        await getToken(); // Assuming getToken fetches the auth token
    int? userId = await getUserId(); // Assuming getToken fetches the auth token
    try {
      var response = await http.get(
        Uri.parse('$baseUrl/get_status/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        emit(StatusLoaded(data['status']));
      } else {
        emit(StatusError(
            'Failed to fetch status with code ${response.statusCode}'));
      }
    } catch (e) {
      emit(StatusError('Failed to fetch status: $e'));
    }
  }

  Future<void> setStatus(String status) async {
    emit(StatusLoading());
    String? token = await getToken();
    int? userId = await getUserId();
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/$status/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        emit(StatusLoaded(data)); // Update with the new status information
      } else {
        emit(StatusError(
            'Failed to set status with code ${response.statusCode}'));
      }
    } catch (e) {
      emit(StatusError('Failed to set status: $e'));
    }
  }

  Future<void> setPaymentStatus() async {
    emit(StatusLoading());
    String? token = await getToken();
    int? userId = await getUserId();
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/pembayaran/$userId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        emit(StatusLoaded(data)); // Update with the new status information
      } else {
        emit(StatusError(
            'Failed to set payment status with code ${response.statusCode}'));
      }
    } catch (e) {
      emit(StatusError('Failed to set payment status: $e'));
    }
  }
}
