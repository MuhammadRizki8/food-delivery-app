import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/cubit/auth_cubit.dart';
import 'package:food_delivery_app/model/auth_state.dart';
import 'package:food_delivery_app/pages/login_page.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                      'Registration Successful! Welcome ${state.username}'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          } else if (state is RegistrationFailed) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.error),
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is RegistrationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().registerUser(
                          _usernameController.text,
                          _passwordController.text,
                        );
                  },
                  child: Text('Register'),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ),
                  child: Text('Already have an account? Login here.'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
