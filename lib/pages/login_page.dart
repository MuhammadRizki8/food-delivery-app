import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/widgets/bottom_navbar.dart';
import 'package:food_delivery_app/cubit/auth_cubit.dart';
import 'package:food_delivery_app/model/auth_state.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          } else if (state is LoginFailed) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Login Failed'),
                content: Text(state.error),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () =>
                        Navigator.of(context).pop(), // Close the dialog
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
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
                    context.read<AuthCubit>().loginUser(
                          _usernameController.text,
                          _passwordController.text,
                        );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
