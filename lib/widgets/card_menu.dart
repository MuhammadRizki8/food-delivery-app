import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data'; // For Uint8List
import '../cubit/items_cubit.dart'; //

class CardMenu extends StatelessWidget {
  const CardMenu({
    super.key,
    required this.item,
    required this.onTap, // Tambahkan callback onTap
  });

  final item;
  final VoidCallback onTap; // Tambahkan jenis untuk callback

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap, // Gunakan onTap
      leading: FutureBuilder<Uint8List?>(
        future: BlocProvider.of<ItemsCubit>(context).fetchImageData(item["id"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return Container(
                width: 100,
                height: 50,
                child: Image.memory(snapshot.data!, fit: BoxFit.cover),
              );
            } else {
              return Icon(Icons.broken_image);
            }
          } else {
            return SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      title: Text(item['title']),
      subtitle: Text(item['description']),
      trailing: Text('Rp ${item['price']}'),
    );
  }
}
