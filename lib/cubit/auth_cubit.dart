import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/model/auth_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> registerUser(String username, String password) async {
    emit(RegistrationLoading());
    try {
      var response = await http.post(
        Uri.parse('http://146.190.109.66:8000/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        emit(RegistrationSuccess(username: data['username'], id: data['id']));
        print("Berhasil Registrasi");
      } else {
        print(response.body);
        emit(RegistrationFailed(error: 'Failed to Register'));
      }
    } catch (e) {
      print(e);
      emit(RegistrationFailed(error: e.toString()));
    }
  }

  Future<void> loginUser(String username, String password) async {
    emit(LoginLoading());
    try {
      var response = await http.post(
        Uri.parse('http://146.190.109.66:8000/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String accessToken = jsonResponse['access_token'];
        int userId = jsonResponse['user_id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setInt('user_id', userId);
        print("berhasil login");
        emit(LoginSuccess(jsonResponse['access_token']));
      } else {
        print(response.body);
        emit(LoginFailed('Failed to login. Please check your credentials.'));
      }
    } catch (e) {
      print(e);
      emit(
          LoginFailed('Error occurred while trying to login: ${e.toString()}'));
    }
  }
}
