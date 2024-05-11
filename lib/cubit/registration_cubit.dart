import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:meta/meta.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

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
}

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String username;
  final int id;

  RegistrationSuccess({required this.username, required this.id});
}

class RegistrationFailed extends RegistrationState {
  final String error;

  RegistrationFailed({required this.error});
}
