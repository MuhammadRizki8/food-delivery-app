import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Definition of the state classes
@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String accessToken;
  LoginSuccess(this.accessToken);
}

class LoginFailed extends LoginState {
  final String error;
  LoginFailed(this.error);
}

// LoginCubit class that manages the state based on the login process
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

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
