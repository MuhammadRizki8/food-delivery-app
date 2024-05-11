import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/cubit/cart_cubit.dart';

class OrderSheet extends StatelessWidget {
  final dynamic item;
  final TextEditingController quantityController = TextEditingController();

  OrderSheet({
    super.key,
    required this.item,
  });

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Success'),
        content: Text('${item['title']} has been added to your cart.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Close the OrderSheet
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartLoaded) {
          _showSuccessDialog(
              context); // Dialog shows and on pressing OK, OrderSheet closes
        } else if (state is CartError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item['title'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(item['description']),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Quantity: '),
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter quantity',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                int quantity = int.tryParse(quantityController.text) ?? 1;
                context.read<CartCubit>().addToCart(item['id'], quantity);
              },
              child: Text('Order ' + item['title']),
            ),
          ],
        ),
      ),
    );
  }
}
