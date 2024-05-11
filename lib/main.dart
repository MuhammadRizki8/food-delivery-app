import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/cubit/cart_cubit.dart';
import 'package:food_delivery_app/cubit/items_cubit.dart';
import 'package:food_delivery_app/cubit/status_cubit.dart';
import 'package:food_delivery_app/pages/registration_page.dart';
import 'cubit/auth_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<ItemsCubit>(
          create: (context) => ItemsCubit()..fetchItemsAll(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<StatusCubit>(
          create: (context) => StatusCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RegistrationPage(), // Default home or could use a navigator
      ),
    );
  }
}
