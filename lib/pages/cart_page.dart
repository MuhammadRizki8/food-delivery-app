import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/cubit/cart_cubit.dart';
import 'package:food_delivery_app/cubit/items_cubit.dart';
import 'package:food_delivery_app/cubit/status_cubit.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartCubit>(context)
        .fetchCartItems(); // Trigger fetching cart items on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => BlocProvider.of<CartCubit>(context)
                .fetchCartItems(), // Refresh the cart list
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartItemDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Item successfully deleted")));
            BlocProvider.of<CartCubit>(context)
                .fetchCartItems(); // Refetch the cart items to update the UI
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CartItemsFetched) {
            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                var cartItem = state.cartItems[index];
                // Assuming ItemsCubit is provided above this in the widget tree
                return BlocBuilder<ItemsCubit, ItemsState>(
                  builder: (itemsContext, itemsState) {
                    if (itemsState is ItemsLoadedAll) {
                      var itemDetail = itemsState.itemsAll.firstWhere(
                          (item) => item['id'] == cartItem['item_id'],
                          orElse: () => null);
                      if (itemDetail != null) {
                        return ListTile(
                          leading: FutureBuilder<Uint8List?>(
                            future: BlocProvider.of<ItemsCubit>(context)
                                .fetchImageData(itemDetail["id"]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return snapshot.hasData
                                    ? Image.memory(snapshot.data!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover)
                                    : Icon(Icons.broken_image);
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                          title: Text(itemDetail['title'] ?? 'No title'),
                          subtitle: Text('Quantity: ${cartItem['quantity']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  'Total: \$${itemDetail['price'] * cartItem['quantity']}'),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  BlocProvider.of<CartCubit>(context)
                                      .deleteCartItem(cartItem['id']);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return ListTile(
                        title: Text('Item details not found'),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                );
              },
            );
          } else if (state is CartError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return Center(child: Text("Your cart is empty or failed to load."));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Call setStatus when checkout button is pressed
          await context.read<StatusCubit>().setStatus("set_status_harap_bayar");
          BlocProvider.of<StatusCubit>(context).fetchStatus();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Checkout successful")));
        },
        label: Text('Checkout'),
        icon: Icon(Icons.shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
