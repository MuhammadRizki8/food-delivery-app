import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/widgets/card_menu.dart';
import 'package:food_delivery_app/widgets/order_sheet.dart';
import '../cubit/items_cubit.dart';

class ItemsPage extends StatelessWidget {
  ItemsPage({Key? key}) : super(key: key);

  void _showItemDetail(BuildContext context, dynamic item) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return OrderSheet(item: item);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Menu'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Items',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                if (value == '') {
                  context.read<ItemsCubit>().fetchItemsAll();
                } else {
                  context.read<ItemsCubit>().fetchItemsFilter(value);
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                if (state is ItemsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ItemsLoadedAll ||
                    state is ItemsLoadedFilter) {
                  var items = state is ItemsLoadedAll
                      ? state.itemsAll
                      : (state as ItemsLoadedFilter).itemsFilter;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return CardMenu(
                        item: item,
                        onTap: () =>
                            _showItemDetail(context, item), // Tambahkan onTap
                      );
                    },
                  );
                } else if (state is ItemsError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text("Start by searching items..."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
